//
//  CartViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import UIKit

class CartViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: CartScreen  {
        baseScreen as! CartScreen
    }
    
    var presenter: CartModuleInterface?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModels: [CartViewModel]? {
        didSet {
            if viewModels?.isEmpty ?? true {
                screen.tableView.showEmpty()
            } else {
                screen.tableView.backgroundView = nil
            }
            screen.buyView.isHidden = viewModels?.isEmpty ?? true
            screen.tableView.reloadData()
        }
    }
    private var hasMoreData = true
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true, isRefreshed: true)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
        setupButton()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
//        navigationItem.leadingTitle = LocalizedKey.myCart.value
        
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItem = notificationBarButtonItem
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
        screen.tableView.refreshControl = refreshControl
    }
    
    private func setupButton() {
        screen.buyButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        presenter?.buy()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false, isRefreshed: true)
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
}

// MARK: CartViewInterface
extension CartViewController: CartViewInterface {
    
    func show(_ models: [CartViewModel]) {
        viewModels = models
    }
    
    func show(_ hasMoreData: Bool) {
        self.hasMoreData = hasMoreData
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
        if screen.tableView.tableFooterView as? UIActivityIndicatorView != nil {
            screen.tableView.tableFooterView = nil
        }
    }
    
    func show(_ notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITableViewDataSource
extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        let viewModel = viewModels?.element(at: indexPath.row)
        cell.viewModel = viewModel
        cell.remove = { [weak self] in
            self?.alertWithOkCancel(message: LocalizedKey.removeCartItemConfirmation.value, title: nil, style: .alert, okTitle: LocalizedKey.delete.value, okStyle: .destructive, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
                self?.presenter?.remove(at: indexPath.row)
            }, cancelAction: nil)
        }
        cell.select = { [weak self] in
            if var viewModel = viewModel {
                viewModel.isSelected.toggle()
                self?.viewModels?[indexPath.row] = viewModel
            }
            self?.presenter?.select(at: indexPath.row)
        }
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item  == (viewModels?.count ?? .zero) - 1 &&
            hasMoreData {
            guard (tableView.tableFooterView as? UIActivityIndicatorView) == nil else {return}
            let activity = UIActivityIndicatorView(style: .medium)
            activity.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 30)
            activity.startAnimating()
            tableView.tableFooterView = activity
            presenter?.viewIsReady(withLoading: false, isRefreshed: false)
        }
    }
    
}
