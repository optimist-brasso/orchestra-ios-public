//
//  IndexVideoDetailViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

import UIKit

class AppendixVideoDetailViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case player,
             detail
    }
    
    // MARK: Properties
    private  var screen: AppendixVideoDetailScreen  {
        baseScreen as! AppendixVideoDetailScreen
    }
    
    var presenter: AppendixVideoDetailModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModel: AppendixVideoDetailViewModel? {
        didSet {
            screen.stackView.isHidden = viewModel == nil
            screen.tableView.reloadData()
        }
    }
    private var cell: AppendixVideoDetailTableViewCell?
    private var downloadState =  DownloadConstants.DownloadState.notDownloaded
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
        setupButton()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupButton() {
        [screen.buttonView.addToCartButton,
         screen.buttonView.buyButton,
         screen.buttonView.backButton].forEach({
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
    }
    
    private func shareButtonTapped() {
        UIApplication.share(viewModel?.orchestra?.description ?? "")
    }
    
    private func setupTableView() {
        screen.tableView.dataSource = self
        screen.tableView.refreshControl = refreshControl
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender {
        case screen.buttonView.addToCartButton:
            if viewModel?.isPartBought ?? false {
                presenter?.addToCart(type: .premium)
            } else {
                presenter?.addToCart(type: .combo)
            }
        case screen.buttonView.buyButton:
            if viewModel?.isPartBought ?? false {
                presenter?.addToCart(type: .premium)
            } else {
                presenter?.addToCart(type: .combo)
            }
        case screen.buttonView.backButton:
            presenter?.previousModule()
        default: break
        }
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
}

// MARK: AppendixVideoDetailViewInterface
extension AppendixVideoDetailViewController: AppendixVideoDetailViewInterface {
    
    func show(_ model: AppendixVideoDetailViewModel) {
        viewModel = model
        screen.viewModel = model
    }
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func showLoginNeed() {
        alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login,
                                                         AlertConstant.cancel]) { [weak self] action  in
            if case .login = action as? AlertConstant {
                self?.presenter?.login()
            }
        }
    }
    
    func show(_ downloadState: DownloadConstants.DownloadState, progress: Float?) {
        self.downloadState = downloadState
        cell?.downloadState = downloadState
        if downloadState == .downloaded {
            cell?.cancelDownloadButton.isHidden = true
//            cell?.downloadButton.isSelected = false
            screen.tableView.beginUpdates()
            cell?.progressInfoStackView.isHidden = true
            screen.tableView.endUpdates()
            cell?.progressView.progress = .zero
        } else {
            if let progress = progress {
                cell?.progressView.progress = progress
                if cell?.progressInfoStackView.isHidden ?? true {
                    UITableView.performWithoutAnimation { [weak self] in
                        self?.screen.tableView.beginUpdates()
                        cell?.progressInfoStackView.isHidden = false
                        self?.screen.tableView.endUpdates()
                    }
                }
            }
            if downloadState == .notDownloaded {
//                cell?.downloadButton.isSelected = false
                cell?.cancelDownloadButton.isHidden = true
                cell?.progressInfoStackView.isHidden = true
            } else if !(cell?.cancelDownloadButton.isSelected ?? false) && downloadState == .downloading {
//                cell?.downloadButton.isSelected = true
                cell?.cancelDownloadButton.isHidden = false
                cell?.progressInfoStackView.isHidden = false
            }
        }
        cell?.cancelDownloadButton.isHidden = downloadState != .downloading
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
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
        presenter?.videoPlayer()
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}

// MARK: UITableViewDataSource
extension AppendixVideoDetailViewController: UITableViewDataSource {
    
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
                return configure(tableView, cellForRowAt: indexPath) as AppendixVideoDetailPlayerTableViewCell
            case .detail:
                return configure(tableView, cellForRowAt: indexPath) as AppendixVideoDetailTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> AppendixVideoDetailPlayerTableViewCell {
        let cell: AppendixVideoDetailPlayerTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.play = { [weak self] in
//            if self?.viewModel?.isPartBought ?? false && self?.viewModel?.isBought ?? false {
//                self?.presenter?.vr()
//                return
//            }
            if self?.downloadState == .downloading {
                self?.tabBarController?.showToast(LocalizedKey.downloadInProgress.value)
                return
            }
            self?.presenter?.videoPlayer()
        }
        cell.viewModel = viewModel
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> AppendixVideoDetailTableViewCell {
        guard let cell = cell else {
            let cell: AppendixVideoDetailTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
            cell.premiumContents = viewModel?.description
            cell.isBought = viewModel?.isBought ?? false
            cell.downloadState = downloadState
            cell.viewModel = viewModel
            cell.organizationChart = { [weak self] in
                self?.presenter?.imageViewer(with: self?.viewModel?.orchestra?.organizationDiagram)
            }
            cell.cancelDownload = { [weak self] in
//                if !cell.downloadButton.isSelected {
//                    self?.presenter?.download()
//                    return
//                }
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
            return cell
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> AppendixVideoDetailDescriptionTableViewCell {
        let cell: AppendixVideoDetailDescriptionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.premiumContents = viewModel?.description
        cell.isBought = viewModel?.isBought ?? false
        cell.viewModel = viewModel?.orchestra
        return cell
    }
        
}
