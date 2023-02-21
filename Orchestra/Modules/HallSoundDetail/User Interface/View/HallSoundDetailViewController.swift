//
//  HallSoundDetailViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

import UIKit
import PBPopupController

class HallSoundDetailViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case title, detail
    }
    
    // MARK: Properties
    private  var screen: HallSoundDetailScreen  {
        baseScreen as! HallSoundDetailScreen
    }
    
    var presenter: HallSoundDetailModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModel: HallSoundDetailViewModel? {
        didSet {
            screen.tableView.reloadData()
        }
    }
    var miniPlayerPlaying: Bool = false
    private var cell: HallSoundTitleTableViewCell?
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if miniPlayerPlaying {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.playAudioMiniPlayer, object: false)
        tabBarController?.tabBar.isHidden = false
        if isMovingFromParent {
            dismissPopUpMiniAudioPlayerViewController()
        }
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.refreshControl = refreshControl
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backTapped))
        
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func openAudioPlayerInMiniMode(_ tag: String?) {
        guard let index = Int(tag ?? "") else {
            return
        }
        presenter?.download(of: index)
    }
    
    private func setupMiniAudioPlayer() {
        if !miniPlayerPlaying {
            miniPlayerPlaying = true
            let customMiniPlayer = UIStoryboard(name: "HallSoundMiniAudioPlayer", bundle: nil).instantiateViewController(withIdentifier: "HallSoundDetailMiniAudioPlayerViewController") as! HallSoundDetailMiniAudioPlayerViewController
            let panGesture = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePanGestureForMiniPlayer(_:)))
            panGesture.cancelsTouchesInView = false
            customMiniPlayer.view.addGestureRecognizer(panGesture)
            popupController.dataSource = self
            popupController.delegate = self
            popupBar.isTranslucent = true
            popupBar.popupBarStyle = .prominent
            popupBar.inheritsVisualStyleFromBottomBar = false
            popupBar.customPopupBarViewController = customMiniPlayer
            popupContentView.popupCloseButton.isHidden = true
            popupContentView.popupIgnoreDropShadowView = true
            popupContentView.backgroundColor = .white
            let popupContentController = HallSoundAudioPlayerWireframe().getMainView()
            tabBarController?.tabBar.isHidden = true
            DispatchQueue.main.async { [weak self] in
                self?.presentPopupBar(withPopupContentViewController: popupContentController, animated: true) {
                    PBLog("Custom Popup Bar Presented")
                }
            }
            if let viewModel = viewModel {
                customMiniPlayer.viewModel = viewModel
            }
        }
    }
    
    private func dismissPopUpMiniAudioPlayerViewController() {
        dismissPopupBar(animated: true)
        tabBarController?.tabBar.isHidden = false
        miniPlayerPlaying = false
        NotificationCenter.default.post(name: Notification.dismissPopUpAudioMiniPlayer, object: nil)
    }
    
    private func frameForBottomBar() -> CGRect {
        let frame = CGRect(x: .zero, y: view.bounds.height, width: view.bounds.width, height: .zero)
        return frame
    }
    
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handlePanGestureForMiniPlayer(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .ended:
            dismissPopUpMiniAudioPlayerViewController()
        default:
            print("Default Case")
        }
    }
    
    private func shareButtonTapped() {
        UIApplication.share(viewModel?.description ?? "")
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
}

// MARK: HallSoundDetailViewInterface
extension HallSoundDetailViewController: HallSoundDetailViewInterface {
    
    func show(_ model: HallSoundDetailViewModel) {
        viewModel = model
    }
    
    func showLoginNeed(for mode: OpenMode?) {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                               AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter?.login(for: mode)
            }
        }
    }
    
    func showBuySuccess() {
        viewModel?.isBought = true
        cell?.viewModel = viewModel
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?) {
        switch downloadState {
        case .notDownloaded:
//            cell?.downloadButton.isSelected = false
            cell?.cancelDownloadButton.isHidden = true
            cell?.progressInfoStackView.isHidden = true
        case .downloading:
            if let progress = progress {
                UITableView.performWithoutAnimation { [weak self] in
                    self?.screen.tableView.beginUpdates()
                    cell?.progressInfoStackView.isHidden = false
                    self?.screen.tableView.endUpdates()
                }
                cell?.progressView.progress = progress
//                cell?.downloadButton.isSelected = true
                cell?.cancelDownloadButton.isHidden = false
            }
        case .downloaded:
            cell?.cancelDownloadButton.isHidden = true
//            cell?.downloadButton.isSelected = false
            screen.tableView.beginUpdates()
            cell?.progressInfoStackView.isHidden = true
            screen.tableView.endUpdates()
            cell?.progressView.progress = .zero
        }
    }
    
    func show(_ error: String) {
        tabBarController?.showToast(error)
    }
    
//    func showAlreadyDownloadingState() {
//        tabBarController?.showToast("Please wait for on going download to finish.")
//    }
    
    func showPlayStatus(of index: Int) {
        guard isTopViewController && presentedViewController == nil else { return }
        setupMiniAudioPlayer()
        let hallsoundViewModel = viewModel?.hallsounds?.element(at: index)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0001) { [weak self] in
            NotificationCenter.default.post(name: Notification.audioMiniPlayerURL, object: (url: hallsoundViewModel?.audioLink, type: hallsoundViewModel?.type))
            if let viewModel = self?.viewModel {
                NotificationCenter.default.post(name: Notification.passHallSoundDetailViewModel, object: (viewModel: viewModel, direction: HallSoundDirection(rawValue: index)))
            }
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
    }
    
    func showFavouriteStatus(_ status: Bool) {
        viewModel?.isFavourite = status
    }
    
    func showDownloadStart() {
        guard let cell = cell else { return }
        UITableView.performWithoutAnimation { [weak self] in
            self?.screen.tableView.beginUpdates()
            cell.progressView.progress = .zero
            cell.progressInfoStackView.isHidden = false
//            cell.downloadButton.isSelected = true
            cell.cancelDownloadButton.isHidden = false
            self?.screen.tableView.endUpdates()
        }
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITableViewDataSource
extension HallSoundDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel == nil ? .zero : Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .title:
                return configure(tableView, cellForRowAt: indexPath) as HallSoundTitleTableViewCell
            case .detail:
                return configure(tableView, cellForRowAt: indexPath) as HallSoundDescriptionTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HallSoundTitleTableViewCell {
        guard let cell = cell else {
            let cell: HallSoundTitleTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.viewModel = viewModel
            cell.buyTapped = { [weak self] in
                self?.presenter?.buy()
            }
            cell.favourite = { [weak self] isFavourite in
                self?.viewModel?.isFavourite = isFavourite
                self?.presenter?.favourite()
            }
            cell.soundViewTapped = { [weak self] tag in
                self?.openAudioPlayerInMiniMode(tag)
            }
            cell.cancelDownload = { [weak self] in
                cell.progressView.progress = .zero
                self?.screen.tableView.beginUpdates()
                cell.cancelDownloadButton.isHidden = true
                cell.progressInfoStackView.isHidden = true
                self?.screen.tableView.endUpdates()
                self?.presenter?.cancelDownload()
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
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HallSoundDescriptionTableViewCell {
        let cell: HallSoundDescriptionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModel
        cell.pageOption = { [weak self] pageOption in
            if pageOption == .session {
                self?.dismissPopUpMiniAudioPlayerViewController()
            }
            self?.presenter?.orchestraDetail(as: pageOption)
        }
        return cell
    }
    
}

//MARK: - PBPopupControllerDataSource
extension HallSoundDetailViewController: PBPopupControllerDataSource {
    
    func popupController(_ popupController: PBPopupController, defaultFrameFor bottomBarView: UIView) -> CGRect {
        return self.frameForBottomBar()
    }
    
    func popupController(_ popupController: PBPopupController, insetsFor bottomBarView: UIView) -> UIEdgeInsets {
        return .zero
    }
    
}

//MARK: - PBPopupControllerDelegate
extension HallSoundDetailViewController: PBPopupControllerDelegate {
    
    func popupControllerTapGestureShouldBegin(_ popupController: PBPopupController, state: PBPopupPresentationState) -> Bool {
        return true
    }
    
    func popupControllerPanGestureShouldBegin(_ popupController: PBPopupController, state: PBPopupPresentationState) -> Bool {
        return true
    }
    
    func popupController(_ popupController: PBPopupController, shouldOpen popupContentViewController: UIViewController) -> Bool {
        self.popupContentView.popupPresentationStyle = .fullScreen
        return true
    }
    
}
