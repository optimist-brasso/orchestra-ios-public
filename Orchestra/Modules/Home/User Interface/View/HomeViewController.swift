//
//  HomeViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

import UIKit

class PointFloatingView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:[imageView, stackLabelView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var stackLabelView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, pointLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .point
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ポイント残高"
        label.textColor = .white
        label.font = .notoSansJPRegular(size: .size14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pointLabel: UILabel = {
        let label = UILabel()
        label.text = "ポイント残高"
        label.textColor = .white
        label.font = .notoSansJPMedium(size: .size18)
        label.textAlignment = .center
        return label
    }()
    
    var point: PointHistory! {
        didSet {
            pointLabel.text =  "\((point.paidPoint + point.freePoint).comma) P"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareLayout() {
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .init(hexString: "#B2964E")
        addSubview(stackView)
        stackView.fillSuperView(inset: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
    }
}

class HomeViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case pageOption, banner, recommendation
    }
    
    // MARK: Properties
    private  var screen: HomeScreen  {
        baseScreen as! HomeScreen
    }
    
    var presenter: HomeModuleInterface?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    private var bannerViewModels: [HomeBannerViewModel]?
    private var point: PointHistory?
    var viewModels: [HomeRecommendationViewModel]? {
        didSet {
            let tableView = screen.tableView
            if (bannerViewModels?.isEmpty ?? true) && (viewModels?.isEmpty ?? true) {
                tableView.showEmpty()
                tableView.tableFooterView = nil
            } else {
                tableView.backgroundView = nil
                tableView.tableFooterView = footerView
            }
            tableView.reloadData()
        }
    }
    
    private lazy var footerView: HomeFooterView = {
        let view = HomeFooterView(frame: CGRect(x: .zero, y: .zero, width: screen.tableView.frame.width, height: 43))
        return view
    }()
    
    // MARK: VC's Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewIsReady(withLoading: true, isRefreshed: true)
    }
    
    // MARK: Other Functions
    private func setup() {
        screen.pointView.isHidden = true
        setupNavBar()
        setupTableView()
        requestNotificationAuthorization()
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        navigationItem.leadingTitle = "Home"
        
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
    }
    
    private func requestNotificationAuthorization() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.viewIsReady(withLoading: false, isRefreshed: true)
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }
    
}

// MARK: HomeViewInterface
extension HomeViewController: HomeViewInterface {
    
    func show(point: PointHistory?) {
        self.point = point
        if let point = point {
            screen.pointView.point = point
            screen.pointView.isHidden = false
            footerView.frame.size.height = screen.pointView.frame.height + 43 + 8
            return
        }
        screen.pointView.isHidden = true
        footerView.frame.size.height = 43
    }
    
    func show(_ models: [HomeRecommendationViewModel]) {
        viewModels = models
    }
    
    func show(_ models: [HomeBannerViewModel]) {
        bannerViewModels = models
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
        screen.tableView.reloadData()
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

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if bannerViewModels == nil {
            return .zero
        }
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section) {
            switch section {
            case .pageOption:
                return 1
            case .banner:
                return bannerViewModels?.isEmpty ?? true ? .zero : 1
            case .recommendation:
                return viewModels?.count ?? .zero
            }
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .pageOption:
                return configure(tableView, cellForRowAt: indexPath) as PageOptionTableViewCell
            case .banner:
                return configure(tableView, cellForRowAt: indexPath) as HomeBannerTableViewCell
            case .recommendation:
                return configure(tableView, cellForRowAt: indexPath) as HomeRecommendationTableViewCell
            }
        }
        return UITableViewCell()
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HomeBannerTableViewCell {
        let cell: HomeBannerTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModels = bannerViewModels
        cell.details = { [weak self] detailsTuple in
            self?.presenter?.bannerDetails(detailsTuple)
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PageOptionTableViewCell {
        let cell: PageOptionTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.didSelect = { [weak self] selectedOption in
            self?.presenter?.homeListing(of: selectedOption)
        }
        return cell
    }
    
    private func configure(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HomeRecommendationTableViewCell {
        let cell: HomeRecommendationTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
        cell.viewModel = viewModels?.element(at: indexPath.row)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.recommendation.rawValue {
            presenter?.details(of: viewModels?.element(at: indexPath.row)?.id)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = Section(rawValue: section), section == .recommendation {
            return (tableView.dequeue(cellForRowAt: IndexPath(row: .zero, section: section.rawValue)) as HomeHeaderTableViewCell).contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let section = Section(rawValue: section),
            section == .recommendation,
            !(viewModels?.isEmpty ?? true) {
            return UITableView.automaticDimension
        }
        return .zero
    }
    
}

@available(iOS 10, *)
//MARK: UNUserNotificationCenterDelegate
extension HomeViewController : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationHandler.shared.receivedNotification(userInfo)
        completionHandler()
    }
    
}
