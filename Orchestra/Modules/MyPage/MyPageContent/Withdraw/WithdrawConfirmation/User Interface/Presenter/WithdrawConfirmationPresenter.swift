//
//  WithdrawConfirmationPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import Foundation

class WithdrawConfirmationPresenter {
    
	// MARK: Properties
    weak var view: WithdrawConfirmationViewInterface?
    var interactor: WithdrawConfirmationInteractorInput?
    var wireframe: WithdrawConfirmationWireframeInput?
    
}

 // MARK: WithdrawConfirmation module interface
extension WithdrawConfirmationPresenter: WithdrawConfirmationModuleInterface {
    
    func withdraw() {
        view?.showLoading()
        interactor?.withdraw()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func logout() {
        interactor?.logout()
    }
    
}

// MARK: WithdrawConfirmation interactor output interface
extension WithdrawConfirmationPresenter: WithdrawConfirmationInteractorOutput {
    
    func obtainedSuccess() {
        view?.hideLoading()
        view?.showSuccess()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
