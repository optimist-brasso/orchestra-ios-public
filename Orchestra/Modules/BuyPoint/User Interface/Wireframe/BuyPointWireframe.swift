//
//  BuyPointWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import UIKit

class BuyPointWireframe {
    private lazy var notificationWireframe: NotificationWireframeInput = {NotificationWireframe()}()
    private lazy var cartWireframe: CartWireframeInput = {CartWireframe()}()
   lazy var freePointWireframe = FreePointWireframe()
    weak var view: UIViewController!
    
}



extension BuyPointWireframe: BuyPointWireframeInput {
    
    var storyboardName: String {return "BuyPoint"}
    
    func getMainView() -> UIViewController {
        let service = BuyPointService()
        let interactor = BuyPointInteractor(service: service)
        let presenter = BuyPointPresenter()
        let screen = BuyPointScreen()
        let viewController = BuyPointViewController(baseScreen: screen)
        viewController.tabBarItem = UITabBarItem(title: LocalizedKey.points.value, image: .coin, selectedImage: nil)
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func gotoFreePoint() {
        let freeController = freePointWireframe.getMainView()
        view.navigationController?.pushViewController( freeController, animated: true)
    }
    
    func openNotification() {
        notificationWireframe.pushMainView(on: view)
    }
    
    func openCart()  {
        cartWireframe.pushMainView(on: view)
    }
}
