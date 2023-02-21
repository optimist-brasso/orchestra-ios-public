//
//  PlaylistContentViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 09/06/2022.
//

import UIKit
import Alamofire

class PlaylistContentViewController: UIViewController {
    
    //MARK: Properties
    let type: OrchestraType
    let presenter: PlaylistModuleInterface?
    var openDetail: (((id: Int?, instrumentId: Int?, musicianId: Int?)) -> Void)?
    var favourite: (((id: Int?, instrumentId: Int?, musicianId: Int?)) -> Void)?
    var refresh: (() -> Void)?
    var isFavouriteBeingTapped: Bool = false
    private var viewModels: [PlaylistViewModel]? {
        didSet {
            if viewModels?.isEmpty ?? true {
                tableView.showEmpty()
            } else {
                tableView.backgroundView = nil
            }
            if !isFavouriteBeingTapped {
                tableView.reloadData()
            }
        }
    }
    var hasMoreData = true
    
    //MARK: UI Properties
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(PlaylistTableViewCell.self)
        tableView.registerCell(PlaylistSessionTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    //MARK: Initilaizers
    init(type: OrchestraType, presenter: PlaylistModuleInterface? = nil) {
        self.type = type
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        setupTableView()
        if type == .session {
            presenter?.viewIsReady(withLoading: false, isRefreshed: false, type: .session)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isFavouriteBeingTapped = false
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func set(_ viewModels: [PlaylistViewModel], reload: Bool) {
        refreshControl.endRefreshing()
        isFavouriteBeingTapped = !reload
        self.viewModels = viewModels
    }
    
    func toggle(session: PlaylistViewModel) {
        isFavouriteBeingTapped = true
        if let index = viewModels?.firstIndex(where: { $0.id == session.id}) {
            viewModels?[index].isSessionFavourite = session.isSessionFavourite 
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PlaylistSessionTableViewCell {
                cell.viewModel?.isSessionFavourite = session.isSessionFavourite
                cell.favouriteButton.isSelected = session.isSessionFavourite 
            }
        }
        isFavouriteBeingTapped = false
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        refresh?()
    }
    
}

// MARK: UITableViewDataSource
extension PlaylistContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .conductor,
                .hallSound:
            return configure(tableView, cellForRowAt: indexPath) as PlaylistTableViewCell
        case .session:
            return configure(tableView, cellForRowAt: indexPath) as PlaylistSessionTableViewCell
        case .player:
            break
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlaylistTableViewCell {
        let cell: PlaylistTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        if var viewModel = viewModels?.element(at: indexPath.row) {
            cell.type = type
            cell.viewModel = viewModel
            cell.favourite = { [weak self] in
                guard let self = self,
                      NetworkReachabilityManager()?.isReachable == true else {
                    self?.showAlert(message: LocalizedKey.noInternet.value)
                    return
                }
                self.isFavouriteBeingTapped = true
                if self.isLoggedIn {
                    switch self.type {
                    case .conductor:
                        viewModel.isConductorFavourite = !viewModel.isConductorFavourite
                    case .session:
                        viewModel.isSessionFavourite = !viewModel.isSessionFavourite
                    case .hallSound:
                        viewModel.isHallSoundFavourite = !viewModel.isHallSoundFavourite
                    case .player:
                        break
                    }
                    self.viewModels?[indexPath.row] = viewModel
                }
                self.favourite?((viewModel.id, nil, nil))
            }
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PlaylistSessionTableViewCell {
        let cell: PlaylistSessionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.row)
        cell.favourite = { [weak self] favouriteTuple in
            self?.favourite?((id: favouriteTuple.orchestraId, instrumentId: favouriteTuple.id, musicianId: favouriteTuple.musicianId))
        }
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension PlaylistContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModels?.element(at: indexPath.row)
        openDetail?((id: viewModel?.id, instrumentId: viewModel?.instrumentId, musicianId: viewModel?.musicianId))
//        presenter?.orchestraDetail(of: viewModels?.element(at: indexPath.row)?.id, type: type)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if hasMoreData &&
            type == .session &&
            indexPath.row == (viewModels?.count ?? .zero) - 1 {
            guard (tableView.tableFooterView as? UIActivityIndicatorView) == nil else {return}
            let activity = UIActivityIndicatorView(style: .medium)
            activity.frame = CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 30)
            activity.startAnimating()
            tableView.tableFooterView = activity
            presenter?.viewIsReady(withLoading: false, isRefreshed: false, type: .session)
        }
    }
    
}

//MARK: LoggedInProtocol
extension PlaylistContentViewController: LoggedInProtocol {}
