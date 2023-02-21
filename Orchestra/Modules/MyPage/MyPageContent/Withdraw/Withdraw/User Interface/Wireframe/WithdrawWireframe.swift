//
//  WithdrawWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import UIKit

class WithdrawWireframe {
    
    weak var view: UIViewController!
    private lazy var withdrawConfirmationWireframe: WithdrawConfirmationWireframeInput = {WithdrawConfirmationWireframe()}()
    
}

extension WithdrawWireframe: WithdrawWireframeInput {
    
    var storyboardName: String {return "Withdraw"}
    
    func getMainView() -> UIViewController {
        let service = WithdrawService()
        let interactor = WithdrawInteractor(service: service)
        let presenter = WithdrawPresenter()
        let screen = WithdrawScreen()
        let viewController = WithdrawViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
    
    func openPreviousModule() {
        view.navigationController?.popViewController(animated: true)
    }
    
    func openConfirmation() {
        view.tabBarController?.present(withdrawConfirmationWireframe.getMainView(), animated: true)
    }
    
}
