//
//  CartPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import Foundation

class CartPresenter {
    
	// MARK: Properties
    weak var view: CartViewInterface?
    var interactor: CartInteractorInput?
    var wireframe: CartWireframeInput?

    // MARK: Converting entities
    private func convert(_ models: [CartStructure]) -> [CartViewModel] {
        return models.map({CartViewModel(type: $0.type,
                                         sessionType: $0.sessionType,
                                         isPremium: $0.isPremium,
                                         title: $0.title,
                                         titleJapanese: $0.titleJapanese,
                                         price: $0.price,
                                         instrument: $0.instrument,
                                         musician: $0.musician,
                                         isSelected: $0.isSelected)})
    }
    
}

 // MARK: Cart module interface
extension CartPresenter: CartModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed)
    }
    
    func remove(at index: Int) {
        view?.showLoading()
        interactor?.remove(at: index)
    }
    
    func select(at index: Int) {
        interactor?.select(at: index)
    }
    
    func buy() {
        view?.showLoading()
        interactor?.buy(withConfirmation: true)
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
}

// MARK: Cart interactor output interface
extension CartPresenter: CartInteractorOutput {
    
    func obtained(_ models: [CartStructure]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(convert(models))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(_ hasMoreData: Bool) {
        view?.show(hasMoreData)
    }
    
    func obtainedSuccess(with message: String) {
        view?.show(NSError(domain: "error", code: 22, userInfo: [NSLocalizedDescriptionKey: message]))
    }
    
    func obtainedCheckoutConfirmationNeed() {
        view?.hideLoading()
        view?.alertWithOkCancel(message: LocalizedKey.checkoutConfirmation.value, title: nil, style: .alert, okTitle: LocalizedKey.ok.value, okStyle: .default, cancelTitle: LocalizedKey.cancel.value, cancelStyle: .cancel, okAction: { [weak self] in
            self?.view?.showLoading()
            self?.interactor?.buy(withConfirmation: false)
        }, cancelAction: nil)
    }
    
    func obtained(_ notificationCount: Int) {
        view?.show(notificationCount)
    }
    
    func obtainedProduct() {
        view?.hideLoading()
    }
    
}
