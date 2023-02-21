//
//  ConductorDetailViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import UIKit
//import Combine

class ConductorDetailViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case player, title, detail
    }
    
    // MARK: Properties
    private  var screen: ConductorDetailScreen  {
        baseScreen as! ConductorDetailScreen
    }
    
    var presenter: ConductorDetailModuleInterface!
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModel: ConductorDetailViewModel? {
        didSet {
            screen.tableView.reloadData()
        }
    }
    private var cell: ConductorDetailTitleTableView?
    private var downloadState = DownloadConstants.DownloadState.notDownloaded
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.changeOrientation(to: .portrait)
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButtonItem
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
    @objc private func cart() {
        presenter.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    private func shareButtonTapped() {
        UIApplication.share(viewModel?.description ?? "")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            changeOrientation(to: .portrait)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    private func changeOrientation(to orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}

// MARK: ConductorDetailViewInterface
extension ConductorDetailViewController: ConductorDetailViewInterface {
    
    func show(_ model: ConductorDetailViewModel) {
        viewModel = model
    }
    
    func showLoginNeed(for mode: OpenMode?) {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                               AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter.login(for: mode)
            }
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?) {
        self.downloadState = downloadState
        guard let cell = cell else { return }
        cell.downloadState = downloadState
        if downloadState == .downloaded {
            screen.tableView.beginUpdates()
            cell.cancelDownloadButton.isHidden = true
//            cell.downloadButton.isSelected = false
            screen.tableView.beginUpdates()
            cell.progressInfoStackView.isHidden = true
            screen.tableView.endUpdates()
            cell.progressView.progress = .zero
            screen.tableView.endUpdates()
        } else {
            if let progress = progress {
                if cell.progressInfoStackView.isHidden  {
                    UITableView.performWithoutAnimation { [weak self] in
                        self?.screen.tableView.beginUpdates()
                        cell.progressInfoStackView.isHidden = false
                        self?.screen.tableView.endUpdates()
                    }
                }
                cell.progressView.progress = progress
            }
            if downloadState == .notDownloaded {
//                cell.downloadButton.isSelected = false
                cell.cancelDownloadButton.isHidden = true
                cell.progressInfoStackView.isHidden = true
            } else if !(cell.cancelDownloadButton.isSelected) && downloadState == .downloading {
//                cell.downloadButton.isSelected = true
                cell.cancelDownloadButton.isHidden = false
                cell.progressInfoStackView.isHidden = false
            }
        }
        cell.cancelDownloadButton.isHidden = downloadState != .downloading
    }
    
    func showDownloadStart() {
        guard let cell = cell else { return }
        downloadState = .downloading
        UITableView.performWithoutAnimation { [weak self] in
            self?.screen.tableView.beginUpdates()
            cell.progressView.progress = .zero
            cell.progressInfoStackView.isHidden = false
//            cell.downloadButton.isSelected = true
            cell.cancelDownloadButton.isHidden = false
            self?.screen.tableView.endUpdates()
        }
    }
    
    func showPlayState() {
        guard isTopViewController && tabBarController?.presentedViewController == nil else { return }
        presenter.vr()
    }
    
    func showFavouriteStatus(_ status: Bool) {
        viewModel?.isFavourite = status
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITableViewDataSource
extension ConductorDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel == nil ? .zero : Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .player:
                return configure(tableView, cellForRowAt: indexPath) as ConductorDetailPlayerTableViewCell
            case .title:
                return configure(tableView, cellForRowAt: indexPath) as ConductorDetailTitleTableView
            case .detail:
                return configure(tableView, cellForRowAt: indexPath) as ConductorDetailTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ConductorDetailTitleTableView {
        guard let cell = cell else {
            let cell: ConductorDetailTitleTableView = tableView.dequeue(cellForRowAt: indexPath)
            cell.downloadState = downloadState
            cell.viewModel = viewModel
            cell.organizationChart = { [weak self] in
                self?.presenter?.imageViewer(with: self?.viewModel?.organizationDiagram)
            }
            cell.favourite = { [weak self] in
                self?.presenter.favourite()
            }
            cell.cancelDownload = { [weak self] in
//                if !cell.downloadButton.isSelected {
//                    self?.presenter.downloadVideo()
//                    return
//                }
                self?.downloadState = .notDownloaded
                self?.cell?.progressView.progress = .zero
                self?.screen.tableView.beginUpdates()
                self?.cell?.cancelDownloadButton.isHidden = true
                self?.cell?.progressInfoStackView.isHidden = true
                self?.screen.tableView.endUpdates()
                self?.presenter.cancelDownload()
            }
            cell.shareButtonTapped = { [weak self] in
                self?.shareButtonTapped()
            }
            self.cell = cell
            return cell
        }
        cell.viewModel = viewModel
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ConductorDetailTableViewCell {
        let cell: ConductorDetailTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModel
        cell.otherOption = { [weak self] option in
            self?.presenter.orchestraDetails(as: option)
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ConductorDetailPlayerTableViewCell {
        let cell: ConductorDetailPlayerTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.image = viewModel?.vrThumbnail
        cell.vrFile = viewModel?.vrFile
        cell.play = { [weak self] in
            if self?.downloadState == .downloading {
                self?.tabBarController?.showToast(LocalizedKey.downloadInProgress.value)
                return
            }
            self?.presenter.vr()
        }
        return cell
    }
    
}
