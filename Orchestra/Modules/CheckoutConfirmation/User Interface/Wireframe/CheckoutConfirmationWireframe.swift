//
//  CheckoutConfirmationWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

import UIKit

class CheckoutConfirmationWireframe {
    
    weak var view: UIViewController!
    var ids: [Int]?
    var orchestraType: OrchestraType = .hallSound
    
}

extension CheckoutConfirmationWireframe: CheckoutConfirmationWireframeInput {
    
    var storyboardName: String {return "CheckoutConfirmation"}
    
    func getMainView() -> UIViewController {
        let service = CheckoutConfirmationService()
        let interactor = CheckoutConfirmationInteractor(service: service)
        interactor.orchestraType = orchestraType
        interactor.ids = ids
        let presenter = CheckoutConfirmationPresenter()
        let screen = CheckoutConfirmationScreen()
        let viewController = CheckoutConfirmationViewController(baseScreen: screen)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        
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
    
}
