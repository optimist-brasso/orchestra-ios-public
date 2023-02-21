//
//  FavoriteContentController.swift
//  Orchestra
//
//  Created by manjil on 02/05/2022.
//

import UIKit

class EmptyDataCell: UICollectionViewCell {

    private lazy var label: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedKey.noData.value
        label.textColor = .gray
        label.font = .notoSansJPRegular(size: .size16)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

class FavoriteContentController: UIViewController {
    
    var search = "" {
        didSet {
            //            search(text: search)
        }
    }
    
    enum Layout {
        case single
        case multiple
    }
    
    var select: ((_ id: Int, _ type: FavouriteType) -> Void)?
    var reloadScreen: ((_ type: FavouriteType) -> Void)?
    
    private(set) lazy var singleGridGroup: UICollectionViewCompositionalLayout = {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: .zero, bottom: .zero, trailing: .zero)
        section.interGroupSpacing = .zero
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private(set) lazy var multipleGridGroup: UICollectionViewCompositionalLayout = {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .zero
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private(set) lazy var emptyGroup: UICollectionViewCompositionalLayout = {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: .zero, bottom: .zero, trailing: .zero)
        section.interGroupSpacing = .zero
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    let tag: Int
    let type: OrchestraType
    private var list: [Favourable] = []
    private var showList: [Favourable] = []
    private var viewModels: [FavouriteViewModel]? {
        didSet {
            if reloadTableView {
                collectionView.reloadData()
            }
        }
    }
    private var presenter: FavouriteModuleInterface
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
        return rc
    }()
    var reloadTableView = true
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: type == .player ? multipleGridGroup : singleGridGroup)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(FavouriteCollectionViewCell.self)
        collectionView.registerCell(FavouritePlayerCollectionViewCell.self)
        collectionView.registerCell(FavouriteSessionCollectionViewCell.self)
        collectionView.registerCell(EmptyDataCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    init(tag: Int, presenter: FavouriteModuleInterface, type: OrchestraType) {
        self.tag = tag
        self.presenter = presenter
        self.type = type
        super.init(nibName: nil, bundle: nil)
        view.tag = tag
    }
    
    let colors: [UIColor] = [.red, .yellow, .blue, .systemPink, .systemCyan, .systemGray]
    var openDetail: (((id: Int?, instrumentId: Int?, musicianId: Int?)) -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layoutIfNeeded()
        view.setNeedsDisplay()
        if type == .session {
            presenter.viewIsReady(showLoading: false, isRefreshed: false, type: type, keyword: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didHandleEndRefresh(_:)), name: GlobalConstants.Notification.didEndRefreshContol.notificationName, object: nil)
    }
    
    @objc func didHandleEndRefresh(_ notification: Notification) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
            collectionView.reloadData()
        }
    }
    
    func updateData(list: [Favourable], tag: Int) {
        if tag == self.tag {
            self.list = list
            showList = list
            if list.isEmpty {
                collectionView.collectionViewLayout = emptyGroup
            } else {
                collectionView.collectionViewLayout  = type == .player ? multipleGridGroup : singleGridGroup
            }
            collectionView.reloadData()
            refreshControl.endRefreshing()
        }
    }

    @objc func reloadPage() {
        let t = FavouriteType(rawValue: tag)
        reloadScreen?(t ?? .conductor)
    }
    
    func set(_ viewModels: [Favourite]) {
        reloadTableView = true
        showList = viewModels
        refreshControl.endRefreshing()
    }
    
    func set(_ viewModels: [FavouriteViewModel]) {
        reloadTableView = true
        if viewModels.isEmpty {
            collectionView.collectionViewLayout = emptyGroup
        } else {
            collectionView.collectionViewLayout  = singleGridGroup
        }
        self.viewModels = viewModels
        refreshControl.endRefreshing()
    }
    
    func remove(model: FavouriteViewModel) {
         reloadTableView  = false
        if let index = viewModels?.firstIndex(where: {$0.id == model.id && $0.instrumentId == model.instrumentId && $0.musicianId == $0.musicianId }) {
            viewModels?.remove(at: index)
            if (viewModels?.isEmpty ?? true) {
                collectionView.collectionViewLayout = emptyGroup
            }
            if isVisible {
                collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            } else {
                collectionView.reloadData()
            }
        }
        reloadTableView = true
    }
}


extension FavoriteContentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .conductor,
                .hallSound,
                .player:
            if showList.isEmpty {
                return 1
            }
            return showList.count
        case .session:
            if viewModels?.isEmpty ?? true {
                return 1
            }
            return viewModels?.count ?? .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (showList.isEmpty && type != .session) || (type == .session && viewModels?.isEmpty ?? true) {
            let cell: EmptyDataCell = collectionView.dequeueCell(for: indexPath)
            return cell
        }
        
        if let favouriteType = FavouriteType(rawValue: tag) {
            switch favouriteType {
            case .player:
                return configure(collectionView, cellForItemAt: indexPath) as FavouritePlayerCollectionViewCell
            case .session:
                return configure(collectionView, cellForItemAt: indexPath) as FavouriteSessionCollectionViewCell
            case .conductor,
                    .hallSound:
                return configure(collectionView, cellForItemAt: indexPath) as FavouriteCollectionViewCell
            }
        } else {
            fatalError("cell should be created")
        }
    }
    
    private func configure(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FavouriteCollectionViewCell {
        let cell: FavouriteCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let data = showList.element(at: indexPath.row) as? Favourite
        cell.data = data
        cell.thumbnailImageView.image = nil
        cell.makeUnfavourite = { [weak self]  id, type in
            guard let self = self else { return }
            self.presenter.makeUnFavorite(id: id, type: type, search: "")
        }
        if let favouriteType = FavouriteType(rawValue: tag) {
            switch favouriteType {
            case .hallSound:
                cell.thumbnailImageView.showImage(with: data?.venueDiagram)
            case .conductor:
                cell.thumbnailImageView.showImage(with: data?.conductorImage)
            default:
                break
            }
        }
        return cell
    }
    
    private func configure(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FavouritePlayerCollectionViewCell {
        let cell: FavouritePlayerCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.data = showList.element(at: indexPath.row) as? FavouritePlayer
        cell.makeUnfavourite = { [weak self] id in
            self?.presenter.unfavoritePlayer(id: id, search: "")
//            self.presenter.makeUnFavoritePlayer(id: id, search: "")
        }
        return cell
    }
    
    private func configure(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FavouriteSessionCollectionViewCell {
        let cell: FavouriteSessionCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let viewModel = viewModels?.element(at: indexPath.item)
        cell.viewModel = viewModel
        cell.unfavourite = { [weak self] in
            self?.presenter.unfavourite(of: viewModel?.id, instrumentId: viewModel?.instrumentId, musicianId: viewModel?.musicianId)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell is EmptyDataCell {
            return 
        }
        if type == .session {
            let viewModel = viewModels?.element(at: indexPath.item)
            openDetail?((id: viewModel?.id, instrumentId: viewModel?.instrumentId, musicianId: viewModel?.musicianId))
            return
        }
        if let favouriteType = FavouriteType(rawValue: tag),
           let select  = select,
           let data = showList.element(at: indexPath.row) {
            select(data.id, favouriteType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is FavouritePlayerCollectionViewCell && !presenter.islastPlayerPage && showList.count - 4 == indexPath.row  {
            presenter.getFavoritePlayer(search: "", type: .player)
        }
    }
}
