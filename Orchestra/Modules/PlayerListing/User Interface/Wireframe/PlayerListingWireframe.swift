//
//  PlayerListingWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class PlayerListingWireframe {
    
    weak var view: UIViewController!
    private lazy var orchestraListingWireframe: OrchestraListingWireframeInput = {OrchestraListingWireframe()}()
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var playerWireframe: PlayerWireframeInput = {PlayerWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    
}

extension PlayerListingWireframe: PlayerListingWireframeInput {
    
    var storyboardName: String {return "PlayerListing"}
    
    func getMainView() -> UIViewController {
        let service = PlayerListingService()
        let interactor = PlayerListingInteractor(service: service)
        let presenter = PlayerListingPresenter()
        let screen = PlayerListingScreen()
        let viewController = PlayerListingViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openOrchestraListing(of type: OrchestraType) {
        if type == .player { return }
        let navigationControllerStackCount = view.navigationController?.viewControllers.count ?? .zero
        orchestraListingWireframe.pageOption = type
        orchestraListingWireframe.pushMainView(on: view, animated: false)
        view.navigationController?.viewControllers.remove(at: navigationControllerStackCount - 1)
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
        //        view.tabBarController?.presentFullScreen(loginWireframe.getMainView(), animated: true)
    }
    
}
