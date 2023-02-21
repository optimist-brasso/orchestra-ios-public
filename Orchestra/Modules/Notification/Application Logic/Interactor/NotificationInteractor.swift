//
//  NotificationInteractor.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Foundation

class NotificationInteractor {
    
	// MARK: Properties
    weak var output: NotificationInteractorOutput?
    private let service: NotificationServiceType
    
    // MARK: Initialization
    init(service: NotificationServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(service.cartCount)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: Notification interactor input interface
extension NotificationInteractor: NotificationInteractorInput {
    
    func getNotification(completion: @escaping (Result<[PushNotification], Error>) -> Void) {
        output?.obtained(service.cartCount)
        service.getNotificationList(completion: completion)
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func read(of id: Int?) {
        guard let id = id else {
            return
        }
        service.read(of: id)
        GlobalConstants.Notification.didReadNotification.fire()
        service.fetchNotificationDetail(of: id) { _ in }
        
    }
    
}
