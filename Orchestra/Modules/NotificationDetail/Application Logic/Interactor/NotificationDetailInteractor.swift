//
//  NotificationDetailInteractor.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Foundation

class NotificationDetailInteractor {
    
	// MARK: Properties
    weak var output: NotificationDetailInteractorOutput?
    private let service: NotificationDetailServiceType
    private var model: PushNotification?
    var id: Int?
    
    // MARK: Initialization
    init(service: NotificationDetailServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: GlobalConstants.Notification.getNotification.notificationName, object: nil)
    }
    
    //MARK: Converting functions
    private func convert(_ model: PushNotification) -> NotificationDetailStructure {
        return NotificationDetailStructure(image: model.image,
                                           title: model.title,
                                           description: model.body,
                                           date: model.createdAt.convertDateFormat(from: .dashYYYYMMDD, to: .slashYYYYMMDD))
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didGetNotification(_ notification: Notification) {
        if let model = notification.object as? PushNotification {
            self.model = model
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: NotificationDetail interactor input interface
extension NotificationDetailInteractor: NotificationDetailInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
        if let id = id {
            service.fetchNotificationDetail(of: id) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.model = model
                    self?.readNotification()
                    if let structure = self?.convert(model) {
                        self?.output?.obtained(structure)
                    }
                case .failure(let error):
                    self?.output?.obtained(error)
                }
            }
        } else if let model = model {
            output?.obtained(convert(model))
        }
    }
    
    func getLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    private func readNotification() {
        if !(model?.isSeen ?? false) {
            service.read(of: id)
            let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
            output?.obtained(notificationCount: notifications.count)
            GlobalConstants.Notification.didReadNotification.fire()
        }
    }
    
}
