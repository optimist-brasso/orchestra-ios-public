//
//  PointHistoryPresenter.swift
//  Orchestra
//
//  Created by manjil on 13/12/2022.
//

import Foundation

protocol PointHistoryModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool)
    
}

protocol PointHistoryViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [PointHistory])
    func endRefreshing()
    func show(_ hasMoreData: Bool)
    func show(_ error: Error)
    
}

class PointHistoryPresenter {
    
    // MARK: Properties
    weak var view: PointHistoryViewInterface?
    var interactor: PointHistoryInteractorInput?
    var wireframe: PointHistoryWireframeInput?
    
}

 // MARK: BillingHistory module interface
extension PointHistoryPresenter: PointHistoryModuleInterface {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool) {
        if withLoading {
            view?.showLoading()
        }
        interactor?.getData(isRefresh: isRefreshed)
    }
    
//    func getData() {
//        interactor?.getData()
//    }
    
}

// MARK: BillingHistory interactor output interface
extension PointHistoryPresenter: PointHistoryInteractorOutput {
    
    func obtained(_ models: [PointHistory]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(models)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(_ hasMoreData: Bool) {
        view?.show(hasMoreData)
    }
    
}
