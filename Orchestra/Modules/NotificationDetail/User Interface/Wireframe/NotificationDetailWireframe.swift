//
//  NotificationDetailWireframe.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import UIKit


class NotificationDetailWireframe {
    
    weak var view: UIViewController!
    var isNotificationDetail: Bool = true
    var id: Int?
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    
}

extension NotificationDetailWireframe: NotificationDetailWireframeInput {
    
    
    
    var storyboardName: String {return "NotificationDetail"}
    
    func getMainView() -> UIViewController {
        let service = NotificationDetailService()
        let interactor = NotificationDetailInteractor(service: service)
        interactor.id = id
        let presenter = NotificationDetailPresenter()
        let viewController = viewControllerFromStoryboard(of: NotificationDetailViewController.self)
        viewController.isNotificationDetail = isNotificationDetail
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openListing() {
        view.navigationController?.popViewController(animated: true)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
        //        view.tabBarController?.presentFullScreen(loginWireframe.getMainView(), animated: true)
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
}
