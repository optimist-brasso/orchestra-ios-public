//
//  PlayerListingViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class PlayerListingViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case pageOption, content
    }
    
    // MARK: Properties
    private  var screen: PlayerListingScreen  {
        baseScreen as! PlayerListingScreen
    }
    
    var presenter: PlayerListingModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModels: [PlayerListingViewModel]? {
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
    private var headerView: PlayerListCollectionViewHeaderView?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true, isRefreshed: true, keyword: nil)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupCollectionView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        
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
        headerView?.searchBar.text = nil
        presenter?.viewIsReady(withLoading: false, isRefreshed: true, keyword: "")
    }
    
}

// MARK: PlayerListingViewInterface
extension PlayerListingViewController: PlayerListingViewInterface {
    
    func show(point: PointHistory?) {
        if let point = point {
            screen.pointView.isHidden = false
            screen.pointView.point = point
            screen.collectionView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: screen.pointView.frame.height + 16, right: .zero)
            return
        }
        screen.pointView.isHidden = true
        screen.collectionView.contentInset = .zero
    }
    
    func show(_ modele: [PlayerListingViewModel]) {
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
extension PlayerListingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.pageOption.rawValue {
            return 1
        }
        return viewModels?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .pageOption:
                return configure(collectionView, cellForItemAt: indexPath) as PlayerListOptionCollectionViewCell
            case .content:
                return configure(collectionView, cellForItemAt: indexPath) as PlayerListCollectionViewCell
            }
        }
        return UICollectionViewCell()
    }
    
    private func configure(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> PlayerListOptionCollectionViewCell {
        let cell: PlayerListOptionCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.selectedPage = .player
        cell.didSelect = { [weak self] option in
            self?.presenter?.homeListing(of: option)
        }
        return cell
    }
    
    private func configure(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> PlayerListCollectionViewCell {
        let cell: PlayerListCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.item)
        return cell
    }
    
}

// MARK: UICollectionViewDelegate
extension PlayerListingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item  == (viewModels?.count ?? .zero) - 1 &&
            hasMoreData {
            presenter?.viewIsReady(withLoading: false, isRefreshed: false, keyword: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Section.content.rawValue {
            presenter?.details(of: viewModels?.element(at: indexPath.item)?.id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView: PlayerListCollectionViewHeaderView = collectionView.dequeue(ofKind: kind, for: indexPath)
            headerView.searchBar.textField?.delegate = self
            self.headerView = headerView
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == Section.content.rawValue {
            return CGSize(width: collectionView.frame.width, height: 43)
        }
        return .zero
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlayerListingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == Section.content.rawValue {
            return UIEdgeInsets(top: 9, left: .zero, bottom: .zero, right: .zero)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == Section.pageOption.rawValue {
            let horizontalSpacing: CGFloat = 40
            let containerViewWidth = collectionView.frame.width - horizontalSpacing
            let internalHorizontalSpacing: CGFloat = 36
            let contentWidth = (containerViewWidth - internalHorizontalSpacing) / 4
            let imageViewHeight = min(90, contentWidth)
            let internalVerticalSpacing: CGFloat = 8
            let verticalSpacing: CGFloat = 13
            let titleHeight: CGFloat = 23
            let height = imageViewHeight + internalVerticalSpacing + titleHeight + verticalSpacing
            return CGSize(width: collectionView.frame.width, height: height)
        }
        let width = collectionView.frame.width / (UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3)
        return CGSize(width: width, height: width * CGFloat(GlobalConstants.AspectRatio.player.height / GlobalConstants.AspectRatio.player.width))
    }
    
}

// MARK: UITextFieldDelegate
extension PlayerListingViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter?.viewIsReady(withLoading: true, isRefreshed: true, keyword: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.viewIsReady(withLoading: true, isRefreshed: true, keyword: textField.text)
        return true
    }
    
}
