//
//  FreePointPresenter.swift
//  Orchestra
//
//  Created by manjil on 20/10/2022.
//

import Foundation


protocol FreePointModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func notification()
    func openCart()
    
}

protocol FreePointViewInterface: AnyObject, BaseViewInterface {
    
    func show(freePoint: [Point])
    func endRefreshing()
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ error: Error)
    
}


class FreePointPresenter: BasePresenter {
    
    var wireframe: FreePointWireframeInput?
    var interactor: FreePointInteractorInput?
    weak var view: FreePointViewInterface?
    
}

// MARK: BuyPoint module interface
extension FreePointPresenter: FreePointModuleInterface {
    func openCart() {
        wireframe?.openCart()
    }
    
  
   func viewIsReady(withLoading: Bool) {
       if withLoading {
           view?.showLoading()
       }
       interactor?.getData()
   }
    
    func notification()  {
        wireframe?.openNotification()
    }
}

extension FreePointPresenter: FreePointInteractorOutput {
    
    func obtained(_ models: [Point]) {
        view?.hideLoading()
        view?.endRefreshing()
        view?.show(freePoint: models)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }

    func obtainedSuccess(with message: String?) {
        view?.hideLoading()
        view?.endRefreshing()
        if let message = message {
            view?.show(NSError(domain: "error", code: 22, userInfo: [NSLocalizedDescriptionKey: message]))
        }
    }
    
    
}
