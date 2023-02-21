//
//  PlayerViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//

import UIKit
import Combine
import SwiftUI

class PlayerViewController: BaseViewController {
    
    var bag = Set<AnyCancellable>()
    
    enum Section: Int, CaseIterable {
        case images, detail, profile, performance
        
        var title: String? {
            switch self {
            case .profile:
                return "PROFILE"
            case .performance:
                return LocalizedKey.performance.value
            default: return nil
            }
        }
    }
    
    // MARK: Properties
    private  var screen: PlayerScreen  {
        baseScreen as! PlayerScreen
    }
    
    var presenter: PlayerModuleInterface!
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var viewModel: PlayerViewModel? {
        didSet {
            screen.tableView.reloadData()
        }
    }
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true)
        presenter.response.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self]  response in
            self?.alert(msg: response.1)
        }.store(in: &bag)
    }
    
    // MARK: Other Functions
    private func setup() {
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        
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
        screen.tableView.estimatedSectionHeaderHeight = 120
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
    
}

// MARK: PlayerViewInterface
extension PlayerViewController: PlayerViewInterface {
    
    func show(_ model: PlayerViewModel) {
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
    
    func show(cartCount: Int) {
        cartBarButtonItem?.badgeNumber = cartCount
    }
    
    func show(notificationCount: Int) {
        notificationBarButtonItem?.badgeNumber = notificationCount
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
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
extension PlayerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel == nil ? .zero : Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section) {
            switch section {
            case .images:
                return viewModel?.images?.isEmpty ?? true ? .zero : 1
            case .detail,
                    .profile:
                return 1
            case .performance:
                return viewModel?.performances?.count ?? .zero
            }
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .images:
                return configure(tableView, cellForRowAt: indexPath) as PlayerImageTableViewCell
            case .detail:
                return configure(tableView, cellForRowAt: indexPath) as PlayerDetailTableViewCell
            case .profile:
                return configure(tableView, cellForRowAt: indexPath) as PlayerProfileTableViewCell
            case .performance:
                return configure(tableView, cellForRowAt: indexPath) as PlayerPerformanceTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlayerImageTableViewCell {
        let cell: PlayerImageTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        //        cell.name = viewModel?.name
        cell.images = viewModel?.images
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlayerDetailTableViewCell {
        let cell: PlayerDetailTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModel
        cell.favourite = { [weak self] in
            self?.presenter.favourite()
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlayerProfileTableViewCell {
        let cell: PlayerProfileTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModel
        cell.openWebsite = { [weak self] link in
            self?.presenter.website(of: link)
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlayerPerformanceTableViewCell {
        let cell: PlayerPerformanceTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModel?.performances?.element(at: indexPath.row)
        return cell
    }
    
}

//MARK: UITableViewDelegate
extension PlayerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let section = Section(rawValue: indexPath.section),
           section == .performance {
            let orchestraId = viewModel?.performances?.element(at: indexPath.row)?.id
            let isVrAvailable: Bool = !(viewModel?.performances?.element(at: indexPath.row)?.vrFile == nil)
            presenter.instrumentDetail(instrumentId: viewModel?.instrumentId,
                                       orchestraId: orchestraId,
                                       musicianId: viewModel?.id,
                                       isVRAvailable: isVrAvailable)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PlayerHeaderTableViewCell.self)") as? PlayerHeaderTableViewCell
        cell?.title = Section(rawValue: section)?.title
        return cell?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Section.performance.rawValue,
           viewModel?.performances?.count ?? .zero <= .zero {
            return .zero
        }
        return (Section(rawValue: section)?.title?.isEmpty ?? true) ? .zero : UITableView.automaticDimension
    }
    
}
