//
//  PremiumVideoDetailsViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import UIKit

class PremiumVideoDetailsViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case player,
             detail,
             description
    }
    
    // MARK: Properties
    private  var screen: PremiumVideoDetailsScreen  {
        baseScreen as! PremiumVideoDetailsScreen
    }
    
    var presenter: PremiumVideoDetailsModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModel: PremiumVideoDetailsViewModel? {
        didSet {
            screen.stackView.isHidden = viewModel == nil
            screen.tableView.reloadData()
        }
    }
    private var cell: PremiumVideoDetailsTableViewCell?
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            changeOrientation(to: .portrait)
        }
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
        setupButton()
        setupImageView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        //        navigationItem.leadingTitle = ""
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.refreshControl = refreshControl
    }
    
    private func setupButton() {
        [screen.buttonView.backButton,
//         screen.buttonView.addToCartButton,
         screen.buttonView.buyButton,
         screen.buttonView.bulkBuyButton,
         screen.buttonView.premiumAppendixButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    private func setupImageView() {
        screen.playerView.playImageView.isUserInteractionEnabled = true
        screen.playerView.playImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPlayer)))
    }
    
    @objc  private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.buttonView.backButton:
            presenter?.previousModule()
//        case screen.buttonView.addToCartButton:
//            presenter?.addToCart(type: .premium)
        case screen.buttonView.buyButton:
            if viewModel?.isPartBought ?? false {
                presenter?.addToCart(type: .premium)
            } else {
                presenter?.addToCart(type: .combo)
            }
        case screen.buttonView.bulkBuyButton:
            presenter?.bulkPurchase()
        case screen.buttonView.premiumAppendixButton:
            presenter?.appendixVideo()
        default: break
        }
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func openPlayer() {
        presenter?.vr()
    }
    
    @objc private func backTapped() {
        if let controllers = navigationController?.viewControllers, controllers.count <= 1 {
            dismiss(animated: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func shareButtonTapped() {
        UIApplication.share(viewModel?.orchestra?.description ?? "")
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
}

// MARK: PremiumVideoDetailsViewInterface
extension PremiumVideoDetailsViewController: PremiumVideoDetailsViewInterface {
    
    func show(_ model: PremiumVideoDetailsViewModel) {
        screen.viewModel = model
        hideLoading()
        viewModel = model
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func showLoginNeed() {
        alert(msg: LocalizedKey.loginRequired.value, actions:[
            AlertConstant.login,
            AlertConstant.cancel]) { [weak self] action  in
                if case .login = action as? AlertConstant {
                    self?.presenter?.login()
                }
            }
    }
    
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?) {
        self.downloadState = downloadState
        if downloadState == .downloaded {
//            cell?.downloadButton.isSelected = false
            cell?.cancelDownloadButton.isHidden = true
            screen.tableView.beginUpdates()
            cell?.progressInfoStackView.isHidden = true
            screen.tableView.endUpdates()
            cell?.progressView.progress = .zero
        } else {
            if let progress = progress {
                UITableView.performWithoutAnimation { [weak self] in
                    self?.screen.tableView.beginUpdates()
                    cell?.progressInfoStackView.isHidden = false
                    self?.screen.tableView.endUpdates()
                    cell?.progressView.progress = progress
                }
            }
            if downloadState == .notDownloaded {
//                cell?.downloadButton.isSelected = false
                cell?.cancelDownloadButton.isHidden = true
                cell?.progressInfoStackView.isHidden = true
            } else if !(cell?.cancelDownloadButton.isSelected ?? false) && downloadState == .downloading {
                if cell?.cancelDownloadButton.isHidden ?? false {
                    cell?.cancelDownloadButton.isHidden = false
                }
//                cell?.downloadButton.isSelected = true
                cell?.progressInfoStackView.isHidden = false
            }
        }
        cell?.cancelDownloadButton.isHidden = downloadState != .downloading
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
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
        presenter?.vr()
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}

// MARK: InstrumentDetailViewInterface
extension PremiumVideoDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .player:
                return configure(tableView, cellForRowAt: indexPath) as PremiumVideoDetailsPlayerTableViewCell
            case .detail:
                return configure(tableView, cellForRowAt: indexPath) as PremiumVideoDetailsTableViewCell
            case .description:
                //                return configure(tableView, cellForRowAt: indexPath) as PremiumVideoDetailsPurchaseTableViewCell
                return configure(tableView, cellForRowAt: indexPath) as PremiumVideoDetailsDescriptionTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PremiumVideoDetailsPlayerTableViewCell {
        let cell: PremiumVideoDetailsPlayerTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.play = { [weak self] in
            if self?.downloadState == .downloading {
                self?.tabBarController?.showToast(LocalizedKey.downloadInProgress.value)
                return
            }
            self?.presenter?.vr()
        }
        cell.viewModel = viewModel
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PremiumVideoDetailsTableViewCell {
        let cell: PremiumVideoDetailsTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.downloadState = downloadState
        cell.viewModel = viewModel
        cell.organizationChart = { [weak self] in
            self?.presenter?.imageViewer(with: self?.viewModel?.orchestra?.organizationDiagram)
        }
        cell.cancelDownload = { [weak self] in
//            if !cell.downloadButton.isSelected {
//                self?.presenter?.download()
//                return
//            }
            self?.downloadState = .notDownloaded
            self?.cell?.progressView.progress = .zero
            self?.screen.tableView.beginUpdates()
            self?.cell?.cancelDownloadButton.isHidden = true
            self?.cell?.progressInfoStackView.isHidden = true
            self?.screen.tableView.endUpdates()
            self?.presenter?.cancelDownload()
        }
        cell.shareButtonTapped = { [weak self] in
            self?.shareButtonTapped()
        }
        cell.favourite = { [weak self] in
            self?.presenter?.favourite()
        }
        self.cell = cell
        cell.favouriteButton.isSelected = viewModel?.isFavourite ?? false
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PremiumVideoDetailsDescriptionTableViewCell {
        let cell: PremiumVideoDetailsDescriptionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.premiumVideoDescription = viewModel?.description
        cell.viewModel = viewModel?.orchestra
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PremiumVideoDetailsPurchaseTableViewCell {
        let cell: PremiumVideoDetailsPurchaseTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        return cell
    }
    
}
