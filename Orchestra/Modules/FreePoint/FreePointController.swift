//
//  FreePointController.swift
//  Orchestra
//
//  Created by manjil on 20/10/2022.
//

import UIKit


class FreePointCell: UITableViewCell {
    
    private(set) lazy var totalPointView: PointHeaderLabel = {
        let view = PointHeaderLabel()
        view.title.text = "ポイント合計"
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title.font = .notoSansJPRegular(size: .size19)
        view.value.font = .notoSansJPMedium(size: .size18)
        view.point.font = .notoSansJPRegular(size: .size18)
        return view
    }()
    
    
    var point: Point! {
        didSet {
            configurationCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func prepareLayout() {
       contentView.addSubview(totalPointView)
       
       NSLayoutConstraint.activate([
        totalPointView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
        totalPointView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        totalPointView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        totalPointView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
       ])
    }
    
    private func configurationCell() {
        if let date = DateFormatter.toDate(dateString: point.date, format: "yyyy/MM/dd", timeZone: .utc) {
            totalPointView.title.text = DateFormatter.toStringJPLocale(date: date, format: "yyyy年MM月dd日まで")
        } else {
            totalPointView.title.text = ""
        }
       
        totalPointView.value.text = "\(point.point)"
    }
    
}

class FreePointScreen: BaseScreen {
    
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .notoSansJPRegular(size: .size18)
        label.text = "ポイント有効期限"
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.backgroundColor = .blueButtonBackground
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(FreePointCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func create() {
        super.create()
        
        addSubview(title)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 21),
            title.heightAnchor.constraint(equalToConstant: 36),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
}

class FreePointController: BaseViewController {
    
    private  var screen: FreePointScreen  {
        baseScreen as! FreePointScreen
    }
    var presenter: FreePointModuleInterface?
    var freePoints: [Point] = [] {
        didSet {
            screen.tableView.reloadData()
        }
    }
    
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewIsReady(withLoading: true)
    }
    
    private func setupUI() {
        setupNavBar()
        setupTableView()
        
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        //navigationItem.leadingTitle = "My Page"
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    
    
    @objc private func cart() {
         presenter?.openCart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false)
    }
}
// MARK: -  UITableViewDelegate, UITableViewDataSource
extension FreePointController: UITableViewDelegate, UITableViewDataSource {
    
    
    private func setupTableView() {
        screen.tableView.delegate = self
        screen.tableView.dataSource = self
        screen.tableView.refreshControl = refreshControl
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        freePoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(FreePointCell.self, for: indexPath)
        cell.point = freePoints[indexPath.row]
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? .white : .init(hexString: "#F5F5F5")
        return cell
    }
}

extension FreePointController: FreePointViewInterface {
    
    func show(freePoint: [Point]) {
        self.freePoints = freePoint
        if freePoint.isEmpty {
            screen.tableView.showEmpty()
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
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription, okAction: { [weak self] in
            self?.endRefreshing()
        })
    }
    
}
