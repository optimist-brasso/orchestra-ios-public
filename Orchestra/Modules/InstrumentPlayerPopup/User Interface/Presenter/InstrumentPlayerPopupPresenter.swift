//
//  InstrumentPlayerPopupPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation

class InstrumentPlayerPopupPresenter {
    
	// MARK: Properties
    weak var view: InstrumentPlayerPopupViewInterface?
    var interactor: InstrumentPlayerPopupInteractorInput?
    var wireframe: InstrumentPlayerPopupWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: InstrumentPlayerPopupStructure) -> InstrumentPlayerPopupViewModel {
        return InstrumentPlayerPopupViewModel(isPartBought: model.isPartBought,
                                              isPremiumBought: model.isPremiumBought)
    }
    
}

 // MARK: InstrumentPlayerPopup module interface
extension InstrumentPlayerPopupPresenter: InstrumentPlayerPopupModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func bulkPurchase() {
        wireframe?.openBulkPurchase()
        interactor?.sendData()
    }
    
    func addToCart(of type: SessionType?) {
        view?.showLoading()
        interactor?.addToCart(of: type)
    }
    
    func buy(of type: SessionType?) {
        view?.showLoading()
        interactor?.buy(of: type)
    }
    
    func premiumVideoPlayer() {
        wireframe?.openPremiumVideoPlayer()
        interactor?.sendData()
    }
    
    func appendixVideoPlayer() {
        wireframe?.openAppendixVideoPlayer()
        interactor?.sendData()
    }
    
}

// MARK: InstrumentPlayerPopup interactor output interface
extension InstrumentPlayerPopupPresenter: InstrumentPlayerPopupInteractorOutput {
    
    func obtained(_ model: InstrumentPlayerPopupStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
    func obtainedSuccess() {
        view?.hideLoading()
        wireframe?.openPreviousModule()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedProduct() {
        view?.hideLoading()
    }
    
}
