//
//  NotificationWireframe.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import UIKit


class NotificationWireframe {
    
    weak var view: UIViewController!
    private lazy var orchestraListingWireframe: OrchestraListingWireframeInput = {OrchestraListingWireframe()}()
    private lazy var playerListingWireframe: PlayerListingWireframeInput = {PlayerListingWireframe()}()
    private lazy var notificationDetailWireframe: NotificationDetailWireframeInput = {NotificationDetailWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    
}

extension NotificationWireframe: NotificationWireframeInput {
    
    var storyboardName: String {return "Notification"}
    
    func getMainView() -> UIViewController {
        let service = NotificationService()
        let interactor = NotificationInteractor(service: service)
        let presenter = NotificationPresenter()
        let viewController = viewControllerFromStoryboard(of: NotificationViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openHomeListing(of type: OrchestraType) {
        if type == .player {
            playerListingWireframe.pushMainView(on: view)
            return
        }
        orchestraListingWireframe.pageOption = type
        orchestraListingWireframe.pushMainView(on: view)
    }
    
    func openNotificationDetail() {
        notificationDetailWireframe.pushMainView(on: view)
    }
    
    func openLogin() {
        if let tabBarController = view.tabBarController {
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
        //        view.tabBarController?.presentFullScreen(loginWireframe.getMainView(), animated: true)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
}
