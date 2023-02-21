//
//  SignupPresenter.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//

import Foundation

class SignupPresenter {
    
	// MARK: Properties
    weak var view: SignupViewInterface?
    var interactor: SignupInteractorInput?
    var wireframe: SignupWireframeInput?
    
}

 // MARK: Signup module interface
extension SignupPresenter: SignupModuleInterface {
    
    func singupWithFacebook() {
        interactor?.signupWithFacebook()
    }
    
    func singupWithEmail() {
        interactor?.signupWithEmail()
    }
    
    func login() {
        
    }
    
    func singupWithLine() {
        interactor?.signupWithLine()
    }
    
}

// MARK: Signup interactor output interface
extension SignupPresenter: SignupInteractorOutput {
    
    func obtained(_ error: Error) {
        view?.show(error)
    }
    
    func obtainedSuccess() {
        view?.resposeSuccess()
    }
    
}
