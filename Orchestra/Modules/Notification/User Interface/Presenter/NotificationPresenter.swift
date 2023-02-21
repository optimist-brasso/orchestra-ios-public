//
//  NotificationPresenter.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Foundation
import Combine

class NotificationPresenter {
    
	// MARK: Properties
    var  list = CurrentValueSubject<[NotificationViewModel], Never>([])
    weak var view: NotificationViewInterface?
    var interactor: NotificationInteractorInput?
    var wireframe: NotificationWireframeInput?
    private var openMode: OpenMode?
    private var models: [PushNotification]?
    
    //MARK: Converting entities
    private func convert(_ models: [PushNotification]) -> [NotificationViewModel] {
        return models.map({NotificationViewModel(id: $0.id,
                                                 image: $0.image,
                                                 title: $0.title,
                                                 description: $0.body,
                                                 date: $0.createdAt.convertDateFormat(from: .dashYYYYMMDD, to: .slashYYYYMMDD),
                                                 color: $0.color,
                                                 isSeen: $0.isSeen)})
    }

}

 // MARK: Notification module interface
extension NotificationPresenter: NotificationModuleInterface {
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getNotification(completion: { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            self.view?.endRefreshing()
            switch result {
            case .success(let data):
                self.models = data
                self.list.send(self.convert(data))
//                self.list.send(data)
            case .failure(let error):
                self.view?.show(error)
            }
        })
    }
    
    func homeListing(of type: OrchestraType) {
        wireframe?.openHomeListing(of: type)
    }
    
    func notificationDetail(of index: Int) {
        let model = models?.element(at: index)
        if !(model?.isSeen ?? false) {
            interactor?.read(of: model?.id)
        }
        wireframe?.openNotificationDetail()
        GlobalConstants.Notification.getNotification.fire(withObject: model)
    }
    
    func cart() {
        openMode = .cart()
        interactor?.getLoginStatus()
    }
    
    func login() {
        wireframe?.openLogin()
    }
    
}

// MARK: Notification interactor output interface
extension NotificationPresenter: NotificationInteractorOutput {
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
            default:
                break
            }
        } else {
            view?.showLoginNeed()
        }
    }
    
    func obtained(_ cartCount: Int) {
        view?.show(cartCount)
    }
    
}
