//
//  HomeListingViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class OrchestraListingViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case pageOption, content
    }
    
    // MARK: Properties
    private  var screen: OrchestraListingScreen  {
        baseScreen as! OrchestraListingScreen
    }
    
    var presenter: OrchestraListingModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    var pageOption: OrchestraType?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModels: [OrchestraListingViewModel]? {
        didSet {
            let tableView = screen.tableView
            if viewModels?.isEmpty ?? true {
                tableView.showEmpty()
            } else {
                tableView.backgroundView = nil
            }
            if oldValue == nil {
                tableView.reloadData()
                tableView.tableFooterView = footerView
                return
            }
            tableView.reloadSections(IndexSet(integer: Section.content.rawValue), with: .none)
        }
    }
    private var headerCell: OrchestraListingHeaderTableViewCell?
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: .zero, y: .zero, width: screen.tableView.frame.width, height: 0))
        return view
    }()
    
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
        screen.pointView.isHidden = true 
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
//        navigationItem.leadingTitle = pageOption?.title
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.delegate = self
        screen.tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        headerCell?.searchBar.text = nil
        presenter?.viewIsReady(withLoading: false, isRefreshed: true)
    }
    
//    @objc private func didChangeText(_ sender: UITextField) {
//        presenter?.search(for: sender.text ?? "")
//    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
}

// MARK: OrchestraListingViewInterface
extension OrchestraListingViewController: OrchestraListingViewInterface {
    
    func show(point: PointHistory?) {
        if let point = point {
            screen.pointView.isHidden = false
            screen.pointView.point = point
            footerView.frame.size.height = screen.pointView.frame.height + 8
            return
        }
        screen.pointView.isHidden = true
        footerView.frame.size.height = .zero
    }
    
    func show(_ models: [OrchestraListingViewModel]) {
        viewModels = models
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        self.screen.tableView.reloadData()
    }
    
    func showLoginNeed(for mode: OpenMode?) {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                         AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter?.login(for: mode)
            }
        }
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
extension OrchestraListingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section) {
            switch section {
            case .pageOption:
                return 1
            case .content:
                return viewModels?.count ?? .zero
            }
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .pageOption:
                return configure(tableView, cellForRowAt: indexPath) as PageOptionTableViewCell
            case .content:
                return configure(tableView, cellForRowAt: indexPath) as OrchestraListingTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PageOptionTableViewCell {
        let cell: PageOptionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.selectedPage = pageOption
        cell.didSelect = { [weak self] option in
            self?.presenter?.orchestraListing(of: option)
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OrchestraListingTableViewCell {
        let cell: OrchestraListingTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.row)
        cell.selectedPage = pageOption
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension OrchestraListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.content.rawValue {
            presenter?.orchestraDetail(of: viewModels?.element(at: indexPath.row)?.id)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == Section.content.rawValue {
            guard let headerCell = headerCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrchestraListingHeaderTableViewCell.self)") as? OrchestraListingHeaderTableViewCell
                cell?.pageOption = pageOption
                cell?.searchBar.textField?.delegate = self
                headerCell = cell
                return cell?.contentView
            }
            return headerCell.contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Section.content.rawValue {
            return 43
        }
        return .zero
    }
    
}

// MARK: UITextFieldDelegate
extension OrchestraListingViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter?.search(for: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.search(for: textField.text ?? "")
        return true
    }
    
}
