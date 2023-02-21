//
//  BuyPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

import Foundation

class BuyPresenter {
    
	// MARK: Properties
    weak var view: BuyViewInterface?
    var interactor: BuyInteractorInput?
    var wireframe: BuyWireframeInput?

    // MARK: Converting entities
    private func convert(_ model: BuyStructure) -> BuyViewModel {
        return BuyViewModel(title: model.title,
                            titleJapanese: model.titleJapanese,
                            venue: model.venue,
                            price: model.price)
    }
    
}

 // MARK: Buy module interface
extension BuyPresenter: BuyModuleInterface {
    
    func viewIsReady() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func buy() {
        view?.showLoading()
        interactor?.buy()
    }
    
    func login() {
        wireframe?.openLogin()
    }
    
    func addToCart() {
        view?.showLoading()
        interactor?.addToCart()
    }
    
}

// MARK: Buy interactor output interface
extension BuyPresenter: BuyInteractorOutput {
    
    func obtained(_ model: BuyStructure) {
        view?.hideLoading()
        view?.show(convert(model))
    }
    
    func obtainedSuccess() {
        view?.hideLoading()
        wireframe?.openPreviousModule()
    }
    
    func obtainedProduct() {
        view?.hideLoading()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
