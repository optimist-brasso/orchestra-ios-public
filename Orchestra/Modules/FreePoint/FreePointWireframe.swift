//
//  FreePointWireframe.swift
//  Orchestra
//
//  Created by manjil on 20/10/2022.
//

import UIKit


protocol FreePointWireframeInput: WireframeInput {
    func openNotification()
    func openCart()
}


class FreePointWireframe {
    
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
    weak var view: UIViewController!
    
}


extension FreePointWireframe: FreePointWireframeInput {
    
    var storyboardName: String {return "FreePoint"}
    
    func getMainView() -> UIViewController {
        let service = FreePointService()
        let interactor = FreePointInteractor(service: service)
        let presenter = FreePointPresenter()
        let screen = FreePointScreen()
        let viewController = FreePointController(baseScreen: screen)
//
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
    func openCart() {
        cartWireframe.pushMainView(on: view)
    }
}
