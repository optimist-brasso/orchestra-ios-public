//
//  WithdrawInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import Foundation

class WithdrawInteractor {
    
	// MARK: Properties
    weak var output: WithdrawInteractorOutput?
    private let service: WithdrawServiceType
    
    // MARK: Initialization
    init(service: WithdrawServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    
}

// MARK: Withdraw interactor input interface
extension WithdrawInteractor: WithdrawInteractorInput {
    
}
