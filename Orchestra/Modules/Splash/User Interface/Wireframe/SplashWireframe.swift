//
//  SplashWireframe.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import UIKit


class SplashWireframe: BaseWireframe  {
    
    var completeSplash: (() ->  Void)?
    var openMode: OpenMode?
    
    override init() {
        super.init()
    }
    
    init(completeSplash: (() ->  Void)? = nil) {
        self.completeSplash = completeSplash
        super.init()
    }
    
    init(openMode: OpenMode? = nil) {
        self.openMode = openMode
        super.init()
    }
    
    override var storyboardName: String {
        "Splash"
    }
    
    override func setViewController() {
        let service = SplashService()
        let interactor = SplashInteractor(service: service)
        if let openMode = NotificationHandler.shared.openMode {
            self.openMode = openMode
            NotificationHandler.shared.openMode = nil
        }
        interactor.redirectionRequired = completeSplash != nil || openMode != nil
        let presenter = SplashPresenter()
        let viewController = viewControllerFromStoryboard(of: SplashViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.completeSplash = completeSplash
        presenter.openMode = openMode
        presenter.view = viewController
        
        self.view = viewController
    }
    
}

extension SplashWireframe: SplashWireframeInput {
    
    func openEditProfile(for email: String?) {
        let wireframe = EditProfileWireframe(email: email, showBackButton: false)
        childWireframe = wireframe
        view.view.window?.rootViewController = LightNavigationController(rootViewController: wireframe.getMainView())
    }
    
    func openHome() {
        view.view.window?.rootViewController = TabBarViewController()
    }
    
}
