//
//  WithdrawConfirmationInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import Foundation

class WithdrawConfirmationInteractor {
    
	// MARK: Properties
    weak var output: WithdrawConfirmationInteractorOutput?
    private let service: WithdrawConfirmationServiceType
    
    // MARK: Initialization
    init(service: WithdrawConfirmationServiceType) {
        self.service = service
    }
    
}

// MARK: WithdrawConfirmation interactor input interface
extension WithdrawConfirmationInteractor: WithdrawConfirmationInteractorInput {
    
    func withdraw() {
        service.withdraw { [weak self] result in
            switch result {
            case .success(_):
                self?.service.clearDatabase()
                Cacher().delete(forKey: .email)
                KeyChainManager.standard.clear()
                self?.output?.obtainedSuccess()
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
    func logout() {
        NotificationCenter.default.post(name: Notification.logoutSuccess, object: nil)
//        NotificationCenter.default.post(name: Notification.userLoggedOut, object: nil)
    }
    
}
