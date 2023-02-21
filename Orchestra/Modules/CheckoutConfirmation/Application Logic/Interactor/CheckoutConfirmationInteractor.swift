//
//  CheckoutConfirmationInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

import Foundation

class CheckoutConfirmationInteractor {
    
	// MARK: Properties
    weak var output: CheckoutConfirmationInteractorOutput?
    private let service: CheckoutConfirmationServiceType
    var orchestraType: OrchestraType = .hallSound
    var ids: [Int]?
    private var models: [CartItem]?
    
    // MARK: Initialization
    init(service: CheckoutConfirmationServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didGetItemsToCheckout(_:)), name: GlobalConstants.Notification.getItemsToCheckout.notificationName, object: nil)
    }

    // MARK: Other functions
    @objc private func didGetItemsToCheckout(_ notification: Notification) {
        if let models = notification.object as? [CartItem] {
            self.models = models
        }
    }
    
}

// MARK: CheckoutConfirmation interactor input interface
extension CheckoutConfirmationInteractor: CheckoutConfirmationInteractorInput {
    
    func checkout(with password: String?) {
        guard let password = password, !password.isEmpty else {
            output?.obtained(NSError(domain: "password-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.passwordRequired.value]))
            return
        }
        guard let models = models else {
            output?.obtained(EK_GlobalConstants.Error.oops)
            return
        }
        service.checkout(items: models) { [weak self] result in
            switch result {
            case .success(_):
                GlobalConstants.Notification.getItemsToCheckout.fire(withObject: true)
                self?.output?.obtainedSuccess()
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
}
