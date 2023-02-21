//
//  AppWireframe.swift
//  Orchestra
//
//  Created by manjil on 11/04/2022.
//

import UIKit
import Combine


class AppWireframe: BaseWireframe {
    
    var forceShowWireframe: BaseWireframe?
    var isAppPreviouslyOpen: Bool {
        Cacher().get(Bool.self, forKey: .isAppPreviouslyOpen) ?? false
    }
    let route:  UINavigationController
    let scene: UIWindow
    
    init(route: UINavigationController, scene: UIWindow?) {
        guard let window = scene else {  fatalError("no window") }
        self.route = route
        self.scene = window
        
        super.init()
        if !isAppPreviouslyOpen {
            KeyChainManager.standard.clear()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(showLogin(_:)), name: Notification.logOut, object: nil)
        NotificationCenter.default.addObserver(forName:  EK_GlobalConstants.Notification.statusCodeNeedsToBeHandled.notificationName, object: nil, queue: nil) { [weak self] _ in
            Cacher().delete(forKey: .email)
            KeyChainManager.standard.clear()
            let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
            DatabaseHandler.shared.delete(object: cartItems)
            self?.openUserLogin()
        }
        if let forceShowWireframe = forceShowWireframe {
            route.setViewControllers([forceShowWireframe.view], animated: false)
            return
        }
        openSplashScreen { [weak self] in
            self?.redirectPage()
        }
    }
    
    private func redirectPage() {
        if !isAppPreviouslyOpen {
            KeyChainManager.standard.clear()
            openOnboarding()
            return
        }
        if UserConstant().isLoggedIn {
            openHomePage()
            return
        }
//        openUserLogin()
        openUserRegisteration()
    }
    
    private func openOnboarding() {
        let wireframe = OnboardingWireframe()
        wireframe.openRegister = { [weak self] in
//            self?.openUserLogin()
            self?.openUserRegisteration()
        }
        childWireframe = wireframe
        route.setViewControllers([wireframe.getMainView()], animated: false)
        scene.rootViewController = route
    }
    
    @objc private func showLogin(_ notification: Notification) {
        let openMode = notification.object as? OpenMode
        openUserLogin(for: openMode)
    }
    
    private func openUserLogin(for mode: OpenMode? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let wireframe = UserLoginWireframe()
            wireframe.openMode = mode
            self.childWireframe = wireframe
            self.route.setViewControllers([wireframe.view], animated: false)
            self.route.navigationBar.isHidden = false 
            self.scene.rootViewController = self.route
        }
    }
    
    private func openUserRegisteration(for mode: OpenMode? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let wireframe = RegisterWireframe()
//            wireframe.openMode = mode
            self.childWireframe = wireframe
            self.route.setViewControllers([wireframe.view], animated: false)
            self.route.navigationBar.isHidden = false
            self.scene.rootViewController = self.route
        }
    }
    
    private func openHomePage() {
        scene.rootViewController = TabBarViewController()
    }
    
    private func openSplashScreen(completion: (() ->  Void)? = nil) {
        let wireframe = SplashWireframe(completeSplash: completion)
        scene.rootViewController = wireframe.getMainView()
    }
    
}
