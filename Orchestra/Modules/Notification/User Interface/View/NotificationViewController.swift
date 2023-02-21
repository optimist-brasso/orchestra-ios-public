//
//  NotificationViewController.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import UIKit
import Combine

class NotificationViewController: UIViewController {
    
    // MARK: Properties
    var presenter: NotificationModuleInterface!
    private var cartBarButtonItem: BadgeBarButtonItem?
    
    var bag = Set<AnyCancellable>()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var isInitialized = false
    
    // MARK: IBOutlets
    @IBOutlet weak var tableview: UITableView!
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.list.subscribe(on: RunLoop.main).receive(on: RunLoop.main).sink { [weak self] listValue in
            if listValue.isEmpty && self?.isInitialized ?? false {
                self?.tableview?.showEmpty()
            } else {
                self?.tableview?.backgroundView = nil
            }
            self?.tableview.reloadData()
            self?.isInitialized = true
        }.store(in: &bag)
        presenter.viewIsReady(withLoading: true)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
//        navigationItem.leadingTitle = "News"
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem = backButtonItem
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        navigationItem.title = ""
    }
    
    private func setupTableView() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.registerNibCell(NotificationTableViewCell.self)
        tableview.registerCell(PageOptionTableViewCell.self)
        tableview.refreshControl = refreshControl
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
    @objc private func navigateBack() {
         view.endEditing(true)
         navigationController?.popViewController(animated: true)
     }
    
}

// MARK: NotificationViewInterface
extension NotificationViewController: NotificationViewInterface {
    
    func showLoginNeed() {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                         AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter.login()
            }
        }
    }
    
    func show(_ cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        tableview.reloadData()
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITableview Datasource
extension NotificationViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == .zero ? 1 : presenter.list.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            return configure(tableView, cellForRowAt: indexPath)
        case 1:
            let cell: NotificationTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.viewModel = presenter.list.value.element(at: indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PageOptionTableViewCell {
        let cell: PageOptionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.didSelect = { [weak self] selectedOption in
            self?.presenter?.homeListing(of: selectedOption)
        }
        return cell
    }
    
}

// MARK: UITableview Delegate
extension NotificationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.notificationDetail(of: indexPath.row)
        if var viewModel = presenter.list.value.element(at: indexPath.row),
           !viewModel.isSeen {
            viewModel.isSeen = true
            presenter.list.value[indexPath.row] = viewModel
        }
//        let item = presenter.list.value[indexPath.row]
//        presenter?.notificationDetail(of: item)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == .zero ? 140 : 105
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return indexPath.section == 0 ? UITableView.automaticDimension : 150
    }
    
}
