//
//  MyPageContentPresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class MyPageContentPresenter {
    
	// MARK: Properties
    weak var view: MyPageContentViewInterface?
    var interactor: MyPageContentInteractorInput?
    var wireframe: MyPageContentWireframeInput?

    // MARK: Converting entities
    
}

 // MARK: MyPageContent module interface
extension MyPageContentPresenter: MyPageContentModuleInterface {
    
    func viewIsReady() {
        interactor?.getData()
    }
    
    func profile() {
        wireframe?.openProfile()
    }
    
    func purchasedContentList() {
        wireframe?.openPurchasedContentList()
    }
    
    func recordingList() {
        wireframe?.openRecordingList()
    }
    
    func logout() {
        interactor?.logout()
    }
    
    func login() {
        wireframe?.openLogin()
    }
    
    func openChangePassword() {
        wireframe?.openChangePassword()
    }
    
    func openBillingHistory() {
        wireframe?.openBillingHistory()
    }
    
    func withdraw() {
        wireframe?.openWithdraw()
    }
    
    func buyPoint() {
        wireframe?.openBuyPoint()
    }
    
}

// MARK: MyPageContent interactor output interface
extension MyPageContentPresenter: MyPageContentInteractorOutput {
    
    func obtainedLoggedIn(status: Bool) {
        view?.showLoggedIn(status: status)
    }
    
    func obtainedSocialLogin(status: Bool) {
        view?.showSocialLogin(status: status)
    }
    
    func obtainedLogoutSuccess() {
        wireframe?.openLogin()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        view?.show(error)
    }
    
}
