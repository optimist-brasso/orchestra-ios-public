//
//  OrchestraPlayerListViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import UIKit

class OrchestraPlayerListViewController: BaseViewController {
    
    // MARK: Properties
    private  var screen: OrchestraPlayerListScreen  {
        baseScreen as! OrchestraPlayerListScreen
    }
    
    var presenter: OrchestraPlayerListModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModels: [OrchestraPlayerListViewModel]? {
        didSet {
            let collectionView = screen.collectionView
            if viewModels?.isEmpty ?? true {
                collectionView.showEmpty()
            } else {
                collectionView.backgroundView = nil
            }
            collectionView.reloadData()
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
        setupCollectionView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
//        navigationItem.leadingTitle = OrchestraType.player.title
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupCollectionView() {
        screen.collectionView.dataSource = self
        screen.collectionView.delegate = self
        screen.collectionView.refreshControl = refreshControl
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false, isRefreshed: true)
    }
    
}

// MARK: OrchestraPlayerListViewInterface
extension OrchestraPlayerListViewController: OrchestraPlayerListViewInterface {
    
    func show(_ modele: [OrchestraPlayerListViewModel]) {
        viewModels = modele
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.collectionView.reloadData()
    }
    
    func show(_ hasMoreData: Bool) {
        self.hasMoreData = hasMoreData
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

// MARK: UICollectionViewDataSource
extension OrchestraPlayerListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OrchestraPlayerListCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.item)
        return cell
    }
    
}

// MARK: UICollectionViewDelegate
extension OrchestraPlayerListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item  == (viewModels?.count ?? .zero) - 1 &&
            hasMoreData {
            presenter?.viewIsReady(withLoading: false, isRefreshed: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.details(of: viewModels?.element(at: indexPath.item)?.id)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension OrchestraPlayerListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / (UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3)
        return CGSize(width: width, height: width * CGFloat(GlobalConstants.AspectRatio.player.height / GlobalConstants.AspectRatio.player.width))
    }
    
}
