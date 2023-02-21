//
//  OrchestraPlayerListWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import UIKit

class OrchestraPlayerListWireframe {
    
    weak var view: UIViewController!
    var id: Int?
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var playerWireframe: PlayerWireframeInput = {PlayerWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    
}

extension OrchestraPlayerListWireframe: OrchestraPlayerListWireframeInput {
    
    var storyboardName: String {return "OrchestraPlayerList"}
    
    func getMainView() -> UIViewController {
        let service = OrchestraPlayerListService()
        let interactor = OrchestraPlayerListInteractor(service: service)
        interactor.id = id
        let presenter = OrchestraPlayerListPresenter()
        let screen = OrchestraPlayerListScreen()
        let viewController = OrchestraPlayerListViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openDetails(of id: Int?) {
        playerWireframe.id = id
        playerWireframe.pushMainView(on: view)
    }
    
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
    
    func openLogin(for mode: OpenMode?) {
        if let tabBarController = view.tabBarController {
            loginWireframe.openMode = mode
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
}
