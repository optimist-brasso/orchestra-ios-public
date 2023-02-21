//
//  TabBarViewController.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//

import UIKit


class TabBarViewController: UITabBarController, LoggedInProtocol {

    //MARK: Properties
    private lazy var homeWireframe: HomeWireframeInput = {HomeWireframe()}()
    private lazy var searchWireframe: SearchWireframeInput = {SearchWireframe()}()
    private lazy var playlistWireframe: PlaylistWireframeInput = {PlaylistWireframe()}()
    private lazy var favouriteWireframe: FavouriteWireframeInput = {FavouriteWireframe()}()
    private lazy var myPageWireframe: MyPageWireframeInput = {MyPageWireframe()}()
    private lazy var buyPointWireframe: BuyPointWireframeInput = {BuyPointWireframe()}()

    
    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        navigationController?.navigationBar.isHidden = true
        delegate = self
    }
    
    //MARK: Other functions
    private func setupTabBar() {
        let viewControllers = [
            LightNavigationController(rootViewController: homeWireframe.getMainView()),
            LightNavigationController(rootViewController: buyPointWireframe.getMainView()),
            LightNavigationController(rootViewController: playlistWireframe.getMainView()),
            LightNavigationController(rootViewController: favouriteWireframe.getMainView()),
            LightNavigationController(rootViewController: myPageWireframe.getMainView())
        ]
        self.viewControllers = viewControllers
    }

}

//MARK: UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let nav = viewController as? LightNavigationController {
            if nav.viewControllers.first is FavouriteViewController {
                open(tab: .favourite)
                if !isLoggedIn {
                    return false
                }
            } else if nav.viewControllers.first is BuyPointViewController {
                open(tab: .point)
                if !isLoggedIn {
                    return false
                }
            }
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == .zero,
           let viewConrollers = (viewController as? UINavigationController)?.viewControllers,
           viewConrollers.count == 1,
           let homeViewController = viewConrollers.first as? HomeViewController,
           homeViewController.viewModels?.count ?? .zero > .zero,
           let screen = homeViewController.baseScreen as? HomeScreen {
            screen.tableView.scrollToRow(at: IndexPath(row: .zero, section: .zero), at: .top, animated: true)
        }
    }
    
}


extension TabBarViewController {
    
    private func open(tab: TabBarIndex) {
        if !isLoggedIn {
            alert(msg: LocalizedKey.loginRequired.value, actions: [AlertConstant.login, AlertConstant.cancel]) {  action  in
                if case .login = action as? AlertConstant {
                    NotificationCenter.default.post(name: Notification.logOut, object: OpenMode.favourite(tab: tab, type: .conductor, id: -1))
                }
            }
        }
    }
    
}
