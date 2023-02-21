//
//  UserLoginPresenter.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

import Foundation
import UIKit
import Combine

class UserLoginPresenter {
    
	// MARK: Properties
    weak var view: UserLoginViewInterface?
    var interactor: UserLoginInteractorInput?
    var wireframe: UserLoginWireframeInput?

}

 // MARK: UserLogin module interface
extension UserLoginPresenter: UserLoginModuleInterface {
    
    func signupWithApple(user: AppleUser) {
        interactor?.signupWithApple(user: user)
    }
    
    func signupWithLine() {
        interactor?.signupWithLine()
    }
    
    func signupWithTwitter() {
        interactor?.signupWithTwitter(from: view!)
    }
    
    func signupWithFacebook() {
        interactor?.signupWithFacebook()
    }
    
    func login(with username: String?, and password: String?) {
        view?.showLoading()
        interactor?.login(with: username, and: password)
    }
    
    func registerWithEmail() {
        wireframe?.openRegister()
    }
    
    func forgotPassword() {
        wireframe?.openForgotPassword()
    }
    
    func home() {
        wireframe?.openHomePage()
    }
    
}

// MARK: UserLogin interactor output interface
extension UserLoginPresenter: UserLoginInteractorOutput {
    
    func showLoading() {
        view?.showLoading()
    }
    
    func hideLoading() {
        view?.hideLoading()
    }
    
    func obtained(_ error: Error) {
        view?.hideLoading()
        if let vc = view as? BaseController {
            vc.alert(msg: error.localizedDescription)
        }
    }
    
    func obtainedSuccess() {
        view?.hideLoading()
        Cacher().setValue(true, key: .isLogin)
        //wireframe?.gotoHomePage()
//        UIApplication.shared.keyWindow?.rootViewController = TabBarViewController()
        wireframe?.openHomePage()
        //view?.alert(message: "Login successful!")
    }
    
    func obtainedProfileUpdateNeed() {
        view?.hideLoading()
        wireframe?.openEditProfile()
    }
    
}


extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
