//
//  CheckoutConfirmationPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

import Foundation

class CheckoutConfirmationPresenter {
    
	// MARK: Properties
    weak var view: CheckoutConfirmationViewInterface?
    var interactor: CheckoutConfirmationInteractorInput?
    var wireframe: CheckoutConfirmationWireframeInput?

    // MARK: Converting entities
    
}

 // MARK: CheckoutConfirmation module interface
extension CheckoutConfirmationPresenter: CheckoutConfirmationModuleInterface {
    
    func checkout(with password: String?) {
        view?.showLoading()
        interactor?.checkout(with: password)
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
}

// MARK: CheckoutConfirmation interactor output interface
extension CheckoutConfirmationPresenter: CheckoutConfirmationInteractorOutput {
    
    func obtainedSuccess() {
        wireframe?.openPreviousModule()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.alert(message: error.localizedDescription)
    }
    
}
