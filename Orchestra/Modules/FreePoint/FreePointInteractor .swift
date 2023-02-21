//
//  FreePointInteractor .swift
//  Orchestra
//
//  Created by manjil on 20/10/2022.
//

import Foundation

protocol FreePointInteractorInput: AnyObject {
    
    func getData()
    
}

protocol FreePointInteractorOutput: AnyObject {
    
    func obtained(_ models: [Point])
    func obtainedSuccess(with message: String?)
    func obtained(_ error: Error)
    func obtained(cartCount: Int)
    func obtained(notificationCount: Int)

}


class FreePointInteractor: FreePointInteractorInput {
    
    let service: FreePointServiceType
    var output: FreePointInteractorOutput?
    
    init(service: FreePointServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
    }
    
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        service.fetchFreePoints { [weak self] result in
            switch result {
            case .success(let models):
                self?.output?.obtained(models)
            case .failure(let error):
                self?.output?.obtained(error)
               
            }
        }
    }
}
