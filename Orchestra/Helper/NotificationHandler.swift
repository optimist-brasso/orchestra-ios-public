//
//  NotificationHandler.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 23/08/2022.
//

import UIKit.UIWindow
import UIKit.UIViewController

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

enum NotificationType: String {
    
    case notificationDetail = "notification-detail"
    
}

class NotificationHandler {
    
    //MARK: Properties
    static let shared = NotificationHandler()
//    fileprivate var oldViewControllers: [UIViewController] = []
    
    private var window: UIWindow? {
        return UIApplication.shared.keyWindowInConnectedScenes
    }
    
    private var topViewController: UIViewController? {
        if var topController = self.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    var openMode: OpenMode?
    
    //wireframes
    private lazy var notificationDetailWireframe: NotificationDetailWireframeInput = {NotificationDetailWireframe()}()
    private lazy var conductorDetailWireframe: ConductorDetailWireframeInput = {ConductorDetailWireframe()}()
    private lazy var hallsoundDetailWireframe: HallSoundDetailWireframeInput = {HallSoundDetailWireframe()}()
    private lazy var sessionDetailWireframe: SessionLayoutWireframeInput = {SessionLayoutWireframe()}()
    private lazy var playerDetailWireframe: PlayerWireframeInput = {PlayerWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var instrumentDetailWireframe: InstrumentDetailWireframeInput = {InstrumentDetailWireframe()}()
    
    //MARK: Initializer
    private init() {}
    
    //MARK: Other functions
    func receivedNotification(_ userInfo: [AnyHashable: Any]) {
        if let typeString = userInfo["type"] as? String,
           let type = NotificationType(rawValue: typeString.lowercased()),
           let id = Int(userInfo["value"] as? String ?? "") {
            switch type {
            case .notificationDetail:
                openNotificationDetail(of: id)
            }
        }
    }
    
    func redirect(for openMode: OpenMode?) {
        if let openMode = openMode {
            switch openMode {
            case .buy(let tab, let type, let id, _, _):
                switch type {
                case .session:
                    openSessionDetail(tab: tab, of: id)
                case .hallSound:
                    openHallsoundDetail(tab: tab, of: id)
                case .player,
                        .conductor:
                    break
                }
            case .favourite(let tab, let type, let id, let instrumentId, let musicianId, let detailNavigation):
                if detailNavigation {
                    switch type {
                    case .conductor:
                        openConductorDetail(tab: tab, of: id)
                    case .session:
                        openInstrumentDetail(tab: tab, of: instrumentId, orchestraId: id, musicianId: musicianId)
                    case .hallSound:
                        openHallsoundDetail(tab: tab, of: id)
                    case .player:
                        openPlayerDetail(tab: tab, of: id)
                    }
                    return
                }
                openTabBar(tab: tab)
            case .cart(let tab):
                openCart(tab: tab)
            case .instrumentDetail(let tab, _, _, let id):
                guard let id = id else {
                    openTabBar(tab: tab)
                    return
                }
                openPlayerDetail(tab: tab, of: id)
            default:
                break
            }
        }
    }
    
    private func openNotificationDetail(of id: Int) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openNotificationDetail() {
            let mainVC = TabBarViewController()
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            notificationDetailWireframe.id = id
            navigationController?.viewControllers.append(notificationDetailWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openNotificationDetail).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openPlayerDetail(tab: TabBarIndex, of id: Int) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openPlayerDetail() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            playerDetailWireframe.id = id
            navigationController?.viewControllers.append(playerDetailWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openPlayerDetail).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openConductorDetail(tab: TabBarIndex, of id: Int) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openConductorDetail() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            conductorDetailWireframe.id = id
            navigationController?.viewControllers.append(conductorDetailWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openConductorDetail).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openInstrumentDetail(tab: TabBarIndex, of id: Int?, orchestraId: Int?, musicianId: Int?) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openInstrumentDetail() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            instrumentDetailWireframe.id = id
            instrumentDetailWireframe.orchestraId = orchestraId
            instrumentDetailWireframe.musicianId = musicianId
            navigationController?.viewControllers.append(instrumentDetailWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openInstrumentDetail).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openHallsoundDetail(tab: TabBarIndex, of id: Int) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openConductorDetail() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            hallsoundDetailWireframe.id = id
            navigationController?.viewControllers.append(hallsoundDetailWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openConductorDetail).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openSessionDetail(tab: TabBarIndex, of id: Int) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openSessionDetail() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            sessionDetailWireframe.id = id
            navigationController?.viewControllers.append(sessionDetailWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openSessionDetail).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openCart(tab: TabBarIndex) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openCart() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            let navigationController = mainVC.selectedViewController as? UINavigationController
            navigationController?.viewControllers.first?.navigationItem.title = ""
            navigationController?.viewControllers.append(cartWireframe.getMainView())
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openCart).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func openTabBar(tab: TabBarIndex) {
        guard window?.rootViewController != nil else {
//            showOnTopView(error: GlobalConstants.Error.oops.localizedDescription)
            return
        }
        
        func openTabBar() {
            let mainVC = TabBarViewController()
            mainVC.selectedIndex = tab.rawValue
            window?.rootViewController = mainVC
        }
        
        let loadingScreenVC = SplashWireframe(completeSplash: openTabBar).getMainView()
        window?.rootViewController = loadingScreenVC
    }
    
    private func showOnTopView(error: String, completion: (()->())? = nil) {
        topViewController?.showAlert(message: error, okAction: completion)
    }
    
}

