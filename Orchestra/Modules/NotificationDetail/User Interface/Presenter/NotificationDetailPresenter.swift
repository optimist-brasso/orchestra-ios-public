//
//  NotificationDetailPresenter.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Foundation

class NotificationDetailPresenter {
    
	// MARK: Properties
    weak var view: NotificationDetailViewInterface?
    var interactor: NotificationDetailInteractorInput?
    var wireframe: NotificationDetailWireframeInput?
    private var openMode: OpenMode?
    
    // MARK: Converting entities
    private func convert(_ model: NotificationDetailStructure) -> NotificationDetailViewModel {
        return NotificationDetailViewModel(image: model.image,
                                           title: model.title,
                                           description: model.description,
                                           date: model.date)
    }
    
}

 // MARK: NotificationDetail module interface
extension NotificationDetailPresenter: NotificationDetailModuleInterface {
    func notification() {
        wireframe?.openNotification()
    }
    
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func listing() {
        wireframe?.openListing()
    }
    
    func cart() {
        let tabBar = wireframe?.view.tabBarController
        openMode = .cart(tab: TabBarIndex(rawValue: tabBar?.selectedIndex ?? .zero) ?? .home)
        interactor?.getLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
}

// MARK: NotificationDetail interactor output interface
extension NotificationDetailPresenter: NotificationDetailInteractorOutput {
    
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
            view?.showLoginNeed(for: openMode)
        }
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func obtained(_ model: NotificationDetailStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
