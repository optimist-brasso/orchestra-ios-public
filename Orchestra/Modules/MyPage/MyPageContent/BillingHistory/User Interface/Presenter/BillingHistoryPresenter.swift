//
//  BillingHistoryPresenter.swift
//  Orchestra
//
//  Created by rohit lama on 09/05/2022.
//
//

import Foundation

class BillingHistoryPresenter {
    
	// MARK: Properties
    weak var view: BillingHistoryViewInterface?
    var interactor: BillingHistoryInteractorInput?
    var wireframe: BillingHistoryWireframeInput?

    // MARK: Converting entities
    private func convert(_ models: [BillingHistoryStructure]) -> [BillingHistoryViewModel] {
        return models.map({BillingHistoryViewModel(title: $0.title,
                                                   date: $0.date,
                                                   price: $0.price,
                                                   type: $0.type,
                                                   instrument: $0.instrument,
                                                   isPremium: $0.isPremium,
                                                   sessionType: $0.sessionType,
                                                   musician: $0.musician)})
    }
    
    private func getConvertedData(_ models: [BillingHistoryMonthlyStructure]) {
        let models = models.map({BillingHistoryMonthlyViewModel(date: $0.date,
                                                                items: convert($0.items ?? []),
                                                                total: $0.total)})
        view?.show(models)
    }
    
}

 // MARK: BillingHistory module interface
extension BillingHistoryPresenter: BillingHistoryModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed)
    }
    
}

// MARK: BillingHistory interactor output interface
extension BillingHistoryPresenter: BillingHistoryInteractorOutput {
    
    func obtained(_ models: [BillingHistoryMonthlyStructure]) {
        view?.hideLoading()
        getConvertedData(models)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(_ hasMoreData: Bool) {
        
    }
    
}
