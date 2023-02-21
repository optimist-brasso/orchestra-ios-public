//
//  InstrumentDetailBuyPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

import Foundation

class InstrumentDetailBuyPresenter {
    
	// MARK: Properties
    weak var view: InstrumentDetailBuyViewInterface?
    var interactor: InstrumentDetailBuyInteractorInput?
    var wireframe: InstrumentDetailBuyWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: InstrumentDetailBuyStructure) -> InstrumentDetailBuyViewModel {
        return InstrumentDetailBuyViewModel(title: model.title,
                                            type: model.type,
                                            price: model.price,
                                            sessionType: model.sessionType)
    }
    
}

 // MARK: InstrumentDetailBuy module interface
extension InstrumentDetailBuyPresenter: InstrumentDetailBuyModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func previousModule() {
        wireframe?.openPreviousModule()
    }
    
    func addToCart() {
        view?.showLoading()
        interactor?.addToCart()
    }
    
    func cart() {
        interactor?.cart()
        wireframe?.openPreviousModule()
    }
    
    func buy() {
        view?.showLoading()
        interactor?.buy()
    }
    
}

// MARK: InstrumentDetailBuy interactor output interface
extension InstrumentDetailBuyPresenter: InstrumentDetailBuyInteractorOutput {
    
    func obtained(_ model: InstrumentDetailBuyStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
    func obtainedAddedInCart() {
        view?.hideLoading()
        view?.showAddedInCart()
    }
    
    func obtainedBuySuccess() {
        view?.hideLoading()
        view?.showBuySuccess()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedProduct() {
        view?.hideLoading()
    }
    
}
