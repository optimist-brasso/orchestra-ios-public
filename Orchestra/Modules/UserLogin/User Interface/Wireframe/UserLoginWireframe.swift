//
//  UserLoginWireframe.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

import UIKit


class UserLoginWireframe: BaseWireframe {
    //  weak var view: UIViewController!
    var openMode: OpenMode?
    
    override var storyboardName: String {
        set {}
        get {
            return "UserLogin"
        }
    }
    
    override func setViewController() {
        let service = UserLoginService()
        let interactor = UserLoginInteractor(service: service)
        let presenter = UserLoginPresenter()
        let viewController = viewControllerFromStoryboard(of: UserLoginViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
    }
    
}

extension UserLoginWireframe: UserLoginWireframeInput {
    
    func openRegister() {
        if view.navigationController?.viewControllers.count ?? .zero > 1 {
            view.navigationController?.popViewController(animated: true)
            return
        }
        NotificationHandler.shared.openMode = openMode
        let wireframe = RegisterWireframe()
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    func openHomePage() {
//        if view.presentingViewController is TabBarViewController {
//            view.dismiss(animated: true)
//            return
//        }
        let wireframe = SplashWireframe(openMode: openMode)
        childWireframe = wireframe
        view.view.window?.rootViewController = wireframe.getMainView()
//        window?.rootViewController = TabBarViewController()
    }
    
    func openForgotPassword() {
        let wireframe = ForgotPasswordWireframe()
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    func openEditProfile() {
        view.view.window?.rootViewController = LightNavigationController(rootViewController: EditProfileWireframe(profile: nil, showBackButton: false).getMainView())
    }
    
}
