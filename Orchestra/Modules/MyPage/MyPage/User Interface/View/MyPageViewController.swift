//
//  MyPageViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AVFoundation

class MyPageViewController: BaseButtonBarPagerTabStripViewController<IconWithLabelCollectionViewCell> {
    
    struct Constants {
        static let headerContentHeight: CGFloat = 349
    }
    
    // MARK: Properties
    var presenter: MyPageModuleInterface?
    var pagerTabStripViewController: [UIViewController]?
    private var cartBarButtonItem: BadgeBarButtonItem?
    private var notificationBarButtonItem: BadgeBarButtonItem?
    private lazy var logoutView: UIView = {
        let view = Bundle.main.loadNibNamed("LogoutView", owner: self, options: nil)?.first as! LogoutView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.logout = { [weak self] in
            self?.logoutUser()
        }
        view.closeView =  { [weak self] in
            self?.showLogoutView(true)
        }
        return view
    }()
 
    // MARK: IBOutlets
    @IBOutlet weak var buttonBarCollection: ButtonBarView!
    @IBOutlet weak var xlPagerContainerView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: VC's Life cycle
    override func viewDidLoad() {
        setupXLPagerBar()
        super.viewDidLoad()
        setupNavBar()
        setupLogoutView()
        presenter?.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "IconWithLabelCollectionViewCell", bundle: Bundle(for: IconWithLabelCollectionViewCell.self), width: { _ in
                return 70.0
        })
    }
    
    // MARK: Other Functions
    private func setupXLPagerBar() {
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 30
        settings.style.buttonBarRightContentInset = 30
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor =  .black
        settings.style.buttonBarItemFont = .appFont(type: .notoSansJP(.regular), size: .size14)
        changeCurrentIndexProgressive = { (oldCell: IconWithLabelCollectionViewCell?, newCell: IconWithLabelCollectionViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.titleLabel?.textColor = UIColor(hexString: "#A8A8A8")
            newCell?.titleLabel?.textColor = .black
            oldCell?.iconImageView?.tintColor = UIColor(hexString: "#A8A8A8")
            newCell?.iconImageView?.tintColor = .black
        }
    }
    
    private func setupNavBar() {
        navigationItem.setCenterLogo()
        navigationItem.leadingTitle = "My Page"
        
        let cartBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.cart, target: self, action: #selector(cart))
        self.cartBarButtonItem = cartBarButtonItem
        let notificationBarButtonItem = BadgeBarButtonItem(image: GlobalConstants.Image.notification, target: self, action: #selector(notification), indicatorColor: .appGreen)
        self.notificationBarButtonItem = notificationBarButtonItem
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notificationBarButtonItem]
    }
    
    private func setupLogoutView() {
        view.addSubview(logoutView)
        NSLayoutConstraint.activate([
            logoutView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 91),
            logoutView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 120 : 45),
            logoutView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        logoutView.isHidden = true
    }
    
    private func logoutUser() {
        presenter?.logout()
    }
    
    @objc private func cart() {
        presenter?.cart()
    }
    
    @objc private func notification() {
        presenter?.notification()
    }

    //MARK: Overridden functions
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return pagerTabStripViewController ?? [UIViewController()]
    }

    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            let child = viewControllers[toIndex] as! IndicatorInfoProvider
            // swiftlint:disable:this force_cast
            UIView.performWithoutAnimation({ [weak self] () -> Void in
                guard let me = self else { return }
                me.navigationItem.leftBarButtonItem?.title =  child.indicatorInfo(for: me).title
            })
        }
    }

    override func configure(cell: IconWithLabelCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        cell.titleLabel?.text = indicatorInfo.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.iconImageView?.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (pagerTabStripViewController?.element(at: indexPath.item) as? UINavigationController)?.popToRootViewController(animated: true)
        moveToViewController(at: indexPath.item)
    }
    
}

// MARK: MyPageViewInterface
extension MyPageViewController: MyPageViewInterface {
    
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

    func showLogoutView(_ interactionStatus: Bool) {
        logoutView.isHidden = interactionStatus
        [buttonBarCollection,
         xlPagerContainerView,
         scrollView,
         tabBarController?.tabBar,
         navigationController?.navigationBar].forEach({
            $0?.isUserInteractionEnabled = interactionStatus})
    }
    
    func show(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }

}
