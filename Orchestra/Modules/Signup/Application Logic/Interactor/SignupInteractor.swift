//
//  SignupInteractor.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//

import Foundation
import LineSDK
import FBSDKLoginKit

class SignupInteractor {
    
    // MARK: Properties
    weak var output: SignupInteractorOutput?
    private let service: SignupServiceType
    
    // MARK: Initialization
    init(service: SignupServiceType) {
        self.service = service
    }
    
}

// MARK: Signup interactor input interface
extension SignupInteractor: SignupInteractorInput {
    
    func signupWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.email, .publicProfile], viewController: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_, _, let token):
                if let accessToken = token?.tokenString {
                    GraphRequest(graphPath: "me").start { connection, result, error in
                        if let result = result as? [String: Any] {
                            self.service.socialApiRequest(token: accessToken,
                                                          userId: result["id"] as! String,
                                                          username: result["name"] as! String,
                                                          type: .facebook) { [weak self] _result in
                                switch _result {
                                case .success(_):
                                    self?.fetchRequiredData()
                                case .failure(let err):
                                    self?.output?.obtained(err)
                                }
                            }
                        }
                    }
                }
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
    
    
    func signupWithEmail() {
        
    }
    
    func signupWithLine() {
        LoginManager.shared.login(permissions: [.profile], in: SignupViewController()) { [weak self]
            result in
            switch result {
            case .success(let loginResult):
//                self?.socialApiRequest(loginResult.accessToken.value,loginResult.userProfile?.userID ?? "", .line)
                self?.service.socialApiRequest(token: loginResult.accessToken.value,
                                              userId: loginResult.userProfile?.userID ?? "",
                                              username: "",
                                              type: .line) { _result in
                    switch _result {
                    case .success(_):
                        self?.fetchRequiredData()
//                        self?.output?.obtainedSuccess()
                    case .failure(let err):
                        self?.output?.obtained(err)
                    }
                }
            case .failure(let error): break
                self?.output?.obtained(error)
            }
        }
    }
    
    private func fetchRequiredData() {
        service.registerFCM { _ in }
        output?.obtainedSuccess()
    }
    
}
