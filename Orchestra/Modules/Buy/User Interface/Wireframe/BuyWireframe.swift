//
//  BuyWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

import UIKit

class BuyWireframe {
    
    weak var view: UIViewController!
    var orchestraType: OrchestraType = .hallSound
    var id: Int?
    private lazy var loginWireframe: UserLoginWireframeInput = {UserLoginWireframe()}()
    
}

extension BuyWireframe: BuyWireframeInput {
    
    var storyboardName: String {return "Buy"}
    
    func getMainView() -> UIViewController {
        let service = BuyService()
        let interactor = BuyInteractor(service: service)
        interactor.id = id
        interactor.orchestraType = orchestraType
        let presenter = BuyPresenter()
        let screen = BuyScreen()
        let viewController = BuyViewController(baseScreen: screen)
        viewController.orchestraType = orchestraType
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openPreviousModule() {
        view.dismiss(animated: true)
    }
    
    func openLogin() {
        if let tabBarController = view.tabBarController {
            tabBarController.presentFullScreen(LightNavigationController(rootViewController: loginWireframe.getMainView()), animated: true)
        }
    }
    
}
