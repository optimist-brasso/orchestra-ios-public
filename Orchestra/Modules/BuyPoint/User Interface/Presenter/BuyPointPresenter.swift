//
//  BuyPointPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import Foundation

class BuyPointPresenter {
    
	// MARK: Properties
    weak var view: BuyPointViewInterface?
    var interactor: BuyPointInteractorInput?
    var wireframe: BuyPointWireframeInput?

    // MARK: Converting entities
    private func convert(_ models: [BuyPointStructure]) -> [BuyPointViewModel] {
        models.map({BuyPointViewModel(title: $0.title,
                                      price: $0.price,
                                      description: $0.description,
                                      image: $0.image)})
    }
    
}

 // MARK: BuyPoint module interface
extension BuyPointPresenter: BuyPointModuleInterface {
    func cart() {
        wireframe?.openCart()
    }
    
    
    func gotoFreePoint() {
        wireframe?.gotoFreePoint()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func viewIsReady(withLoading: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(showAlert: false)
    }
    
    func buy(at index: String) {
        view?.showLoading()
        interactor?.buy(at: index)
    }
    
}

// MARK: BuyPoint interactor output interface
extension BuyPointPresenter: BuyPointInteractorOutput {
    
    func obtained(_ models: PointHistory) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(models)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedSuccess(with message: String?) {
        view?.hideLoading()
        view?.endRefreshing()
        if let message = message {
            view?.show(NSError(domain: "error", code: 22, userInfo: [NSLocalizedDescriptionKey: message]))
        }
    }
    
    func obtained(points: String) {
        view?.show(points: points)
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
}
