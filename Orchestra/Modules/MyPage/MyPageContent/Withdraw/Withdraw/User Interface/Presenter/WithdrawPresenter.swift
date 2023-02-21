//
//  WithdrawPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import Foundation

class WithdrawPresenter {
    
	// MARK: Properties
    weak var view: WithdrawViewInterface?
    var interactor: WithdrawInteractorInput?
    var wireframe: WithdrawWireframeInput?

    // MARK: Converting entities
    
}

 // MARK: Withdraw module interface
extension WithdrawPresenter: WithdrawModuleInterface {
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func confirmation() {
        wireframe?.openConfirmation()
    }
    
}

// MARK: Withdraw interactor output interface
extension WithdrawPresenter: WithdrawInteractorOutput {
    
}
