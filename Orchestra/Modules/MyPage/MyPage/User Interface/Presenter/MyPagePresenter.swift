//
//  MyPagePresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

import Foundation

class MyPagePresenter {
    
	// MARK: Properties
    weak var view: MyPageViewInterface?
    var interactor: MyPageInteractorInput?
    var wireframe: MyPageWireframeInput?
    private var openMode: OpenMode?

    // MARK: Converting entities
    
}

 // MARK: MyPage module interface
extension MyPagePresenter: MyPageModuleInterface {
    
    func viewIsReady() {
        interactor?.getData()
    }
    
    func notification() {
        wireframe?.openNotification()
    }
    
    func cart() {
        openMode = .cart(tab: .myPage)
        interactor?.checkLoginStatus()
    }
    
    func login(for mode: OpenMode?) {
        wireframe?.openLogin(for: mode)
    }
    
    func logout() {
        view?.showLoading()
        interactor?.logout()
    }
    
}

// MARK: MyPage interactor output interface
extension MyPagePresenter: MyPageInteractorOutput {
    
    func obtainedLoginStatus(_ status: Bool) {
        if status, let openMode = openMode {
            self.openMode = nil
            switch openMode {
            case .cart:
                wireframe?.openCart()
            default:
                break
            }
        } else {
            view?.showLoginNeed(for: openMode)
        }
    }
    
    func obtained(cartCount: Int) {
        view?.show(cartCount: cartCount)
    }
    
    func obtained(notificationCount: Int) {
        view?.show(notificationCount: notificationCount)
    }
    
    func openLogoutView() {
        view?.showLogoutView(false)
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
    func obtainedSuccess() {
        view?.hideLoading()
    }
    
}
