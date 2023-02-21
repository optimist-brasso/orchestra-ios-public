//
//  WithdrawConfirmationWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import UIKit

class WithdrawConfirmationWireframe {
    
    weak var view: UIViewController!
    
}

extension WithdrawConfirmationWireframe: WithdrawConfirmationWireframeInput {
    
    var storyboardName: String {return "WithdrawConfirmation"}
    
    func getMainView() -> UIViewController {
        let service = WithdrawConfirmationService()
        let interactor = WithdrawConfirmationInteractor(service: service)
        let presenter = WithdrawConfirmationPresenter()
        let screen = WithdrawConfirmationScreen()
        let viewController = WithdrawConfirmationViewController(baseScreen: screen)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
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
