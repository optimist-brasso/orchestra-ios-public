//
//  BulkInstrumentPurchasePresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

import Foundation

class BulkInstrumentPurchasePresenter {
    
	// MARK: Properties
    weak var view: BulkInstrumentPurchaseViewInterface?
    var interactor: BulkInstrumentPurchaseInteractorInput?
    var wireframe: BulkInstrumentPurchaseWireframeInput?

    // MARK: Converting entities
    private func convert(_ models: [BulkInstrumentPurchaseStructure]) -> [BulkInstrumentPurchaseViewModel] {
        return models.map({BulkInstrumentPurchaseViewModel(id: $0.id,
                                                           musician: $0.musician,
                                                           image: $0.image,
                                                           instrument: $0.instrument,
                                                           isPartBought: $0.isPartBought,
                                                           isPremiumBought: $0.isPremiumBought)})
    }
}

 // MARK: BulkInstrumentPurchase module interface
extension BulkInstrumentPurchasePresenter: BulkInstrumentPurchaseModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func buy() {
        view?.showLoading()
        interactor?.buy()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func cart() {
        wireframe?.openCart()
    }
    
    func addToCart() {
        view?.showLoading()
        interactor?.addToCart()
    }
    
    func select(at index: Int) {
        interactor?.select(at: index)
    }
    
}

// MARK: BulkInstrumentPurchase interactor output interface
extension BulkInstrumentPurchasePresenter: BulkInstrumentPurchaseInteractorOutput {
    
    func obtained(title: String?, japaneseTitle: String?) {
        view?.show(title: title, japaneseTitle: japaneseTitle)
    }
    
    func obtained(_ models: [BulkInstrumentPurchaseStructure]) {
        view?.hideLoading()
        view?.show(convert(models))
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedConfirmationNeed() {
        view?.hideLoading()
        wireframe?.openConfirmation()
        interactor?.sendData()
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func obtainedSuccess() {
        view?.hideLoading()
        wireframe?.openSuccessView()
        interactor?.sendData()
//        view?.alert(message: LocalizedKey.addedInCart.value)
    }
    
}
