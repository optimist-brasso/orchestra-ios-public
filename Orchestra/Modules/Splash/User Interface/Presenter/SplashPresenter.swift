//
//  SplashPresenter.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import Foundation


class SplashPresenter {
    
	// MARK: Properties
    weak var view: SplashViewInterface?
    var interactor: SplashInteractorInput?
    var wireframe: SplashWireframeInput?
    var completeSplash: (() -> Void)?
    var openMode: OpenMode?
    
}

 // MARK: Splash module interface
extension SplashPresenter: SplashModuleInterface {
    
    func requestAppInfo() {
        view?.startLoading()
        interactor?.getData()
//        interactor?.requestAppInfo()
    }
    
}

// MARK: Splash interactor output interface
extension SplashPresenter: SplashInteractorOutput {
    
    func obtainedSuccess() {
        view?.stopLoading()
        if let openMode = NotificationHandler.shared.openMode {
            self.openMode = openMode
            NotificationHandler.shared.openMode = nil
        }
        if let openMode = openMode {
            self.openMode = nil
            NotificationHandler.shared.redirect(for: openMode)
        } else if let completeSplash = completeSplash {
            completeSplash()
            self.completeSplash = nil
        } else {
            wireframe?.openHome()
//            wireframe.open
        }
        view?.obtainedSuccess()
    }
    
    func obtained(_ error: Error) {
        view?.stopLoading()
        view?.show(error)
    }
    
    func obtainedProfileUpdateNeed(for email: String?) {
        view?.stopLoading()
        wireframe?.openEditProfile(for: email)
    }
    
}
