//
//  BulkInstrumentBuyConfirmationPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

import Foundation

class BulkInstrumentBuyConfirmationPresenter {
    
	// MARK: Properties
    weak var view: BulkInstrumentBuyConfirmationViewInterface?
    var interactor: BulkInstrumentBuyConfirmationInteractorInput?
    var wireframe: BulkInstrumentBuyConfirmationWireframeInput?

    // MARK: Converting entities
    
}

 // MARK: BulkInstrumentBuyConfirmation module interface
extension BulkInstrumentBuyConfirmationPresenter: BulkInstrumentBuyConfirmationModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func buy() {
        view?.showLoading()
        interactor?.buy()
    }
    
    func addToCart() {
        view?.showLoading()
        interactor?.addToCart()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func cart() {
        interactor?.cart()
        wireframe?.openPreviousModule()
    }
    
}

// MARK: BulkInstrumentBuyConfirmation interactor output interface
extension BulkInstrumentBuyConfirmationPresenter: BulkInstrumentBuyConfirmationInteractorOutput {
    
    func obtained(title: String?, japaneseTitle: String?) {
        view?.show(title: title, japaneseTitle: japaneseTitle)
        view?.hideLoading()
    }
    
    func obtained(_ buySuccess: Bool, total: String) {
        view?.hideLoading()
        view?.show(buySuccess, total: total)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
