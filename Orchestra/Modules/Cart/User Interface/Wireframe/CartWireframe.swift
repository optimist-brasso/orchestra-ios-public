//
//  CartWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import UIKit

class CartWireframe {
    
    weak var view: UIViewController!
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var checkoutConfirmationWireframe: CheckoutConfirmationWireframeInput = {CheckoutConfirmationWireframe()}()
    
}

extension CartWireframe: CartWireframeInput {
    
    var storyboardName: String {return "Cart"}
    
    func getMainView() -> UIViewController {
        let service = CartService()
        let interactor = CartInteractor(service: service)
        let presenter = CartPresenter()
        let screen = CartScreen()
        let viewController = CartViewController(baseScreen: screen)
        
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
    
    func openCheckoutConfirmation() {
        view.tabBarController?.present(checkoutConfirmationWireframe.getMainView(), animated: true)
    }
    
}
