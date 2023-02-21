//
//  BuyPointViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import UIKit

class BuyPointViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: BuyPointScreen  {
        baseScreen as! BuyPointScreen
    }
    
    var presenter: BuyPointModuleInterface?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    
    private var viewModels: PointHistory? {
        didSet {
            let tableView = screen.tableView
            if viewModels?.bundleList.isEmpty ?? true {
                tableView.showEmpty()
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        }
    }
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true)
        
        IAP.shared.fetchLatestReceipt {  [weak self] (receiptData, error) in
            guard let self = self else { return }
            if let receiptData = receiptData {
                let receiptValue = receiptData.base64EncodedString(options: [])
                print(receiptValue)
                IAP.shared.verify(receipt: receiptValue) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_ ):
                        self.presenter?.viewIsReady(withLoading: false)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        let tableView = screen.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        navigationItem.leadingTitle = "Point"
        // let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backTapped))
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        //  navigationItem.leftBarButtonItems = [backButtonItem]
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
}

// MARK: BuyPointViewInterface
extension BuyPointViewController: BuyPointViewInterface {
    
    func show(_ models: PointHistory) {
        viewModels = models
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
    }
    
    func show(points: String) {
        screen.titleLabel.text = "\(LocalizedKey.points.value): \(points)"
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITableViewDataSource
extension BuyPointViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.bundleList.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PointCell.self, for: indexPath)
        cell.point = viewModels?.bundleList[indexPath.row]
        cell.buy = { [weak self] identifier in
            self?.alertWithOkCancel(message: LocalizedKey.buyPointWarning.value, title: nil, style: .alert, okTitle: LocalizedKey.ok.value, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
                self?.presenter?.buy(at: identifier)
            }, cancelAction: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let viewModels = viewModels {
            let view = tableView.dequeue(PointHeader.self)
            view.goToFreePoint = { [weak self] in
                self?.presenter?.gotoFreePoint()
            }
            view.totalPointView.value.text = "\((viewModels.paidPoint + viewModels.freePoint).comma)"
            view.paidPointView.value.text =  "\(viewModels.paidPoint.comma)"
            view.limitedTimePointView.value.text =  "\(viewModels.freePoint.comma)"
            view.expirePointView.isHidden = viewModels.firstExpiry == nil
            if let firstExpiry = viewModels.firstExpiry {
                view.expirePointView.isHidden =  firstExpiry.date.isEmpty
                view.expirePointView.title.text =  ""
                if  let date = DateFormatter.toDate(dateString: firstExpiry.date, format: "yyyy/MM/dd", timeZone: .utc) {
                    let dateString = DateFormatter.toStringJPLocale(date: date, format: "yyyy年MM月dd日まで") // 2022年08月31日まで
                    view.expirePointView.title.text = dateString
                }
                view.expirePointView.value.text = "\(firstExpiry.point?.comma ?? "")"
            }
            if  let date = viewModels.secondExpiry?.date,
                let secondExpiryDate = DateFormatter.toDate(dateString:  date, format: "yyyy/MM/dd", timeZone: .utc) {
                view.expire2PointView.title.text =  DateFormatter.toStringJPLocale(date: secondExpiryDate, format: "yyyy年MM月dd日まで")
            } else {
                view.expire2PointView.title.text = ""
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

// MARK: UITableViewDelegate
extension BuyPointViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
}


