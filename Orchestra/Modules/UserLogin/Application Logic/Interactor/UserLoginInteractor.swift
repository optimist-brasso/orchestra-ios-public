//
//  UserLoginInteractor.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 17/02/2022.
//
//

import Foundation
import LineSDK

import FBSDKLoginKit
import FirebaseAuth
import Alamofire

class UserLoginInteractor {
    
    // MARK: Properties
    weak var output: UserLoginInteractorOutput?
    private let service: UserLoginServiceType
    
    private let dispatchGroup = DispatchGroup()
    private var profileStatus = false
    private var provider: OAuthProvider?
    // MARK: Initialization
    init(service: UserLoginServiceType) {
        self.service = service
    }
    
}

// MARK: UserLogin interactor input interface
extension UserLoginInteractor: UserLoginInteractorInput {
    
    func signupWithApple(user: AppleUser) {
        output?.showLoading()
        service.socialLogin(accessToken: user.idToken, userIdentifier: user.userId, name: nil, type: .apple) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchRequiredData()
            case .failure(let err):
                self?.output?.obtained(err)
            }
        }
    }
    
    func signupWithTwitter(from view: UserLoginViewInterface) {
        do {
            try  Auth.auth().signOut()
            
        } catch {
            print(error.localizedDescription)
        }
        
        self.output?.showLoading()
        provider = OAuthProvider(providerID: "twitter.com")
        provider?.getCredentialWith(nil) { [weak self] credential, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                self.output?.hideLoading()
                self.output?.obtained(NSError(domain: "login-error", code: error._code, userInfo: [NSLocalizedDescriptionKey:  LocalizedKey.loginFail.value]))
                return
            }
            if let credential = credential {
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    guard let self = self else { return }
                    if let error = error {
                        print(error.localizedDescription)
                        self.output?.hideLoading()
                        self.output?.obtained(NSError(domain: "login-error", code: error._code, userInfo: [NSLocalizedDescriptionKey:  LocalizedKey.loginFail.value]))
                        return
                    }
                    if let authResult = authResult {
                        let credential = (authResult.credential as? OAuthCredential)
                        self.output?.showLoading()
                        self.service.socialLogin(accessToken: credential?.accessToken ?? "",
                                                 userIdentifier: credential?.secret ?? "",
                                                 type: .twitter) { _result in
                            switch _result {
                            case .success(_):
                                self.fetchRequiredData()
                            case .failure(let err):
                                self.output?.obtained(err)
                            }
                        }
                        print(authResult)
                    }
                }
            }
        }
        
    }
    
    func signupWithLine() {
        output?.showLoading()
        LoginManager.shared.login(permissions: [.profile], in: SignupViewController()) { [weak self]
            result in
            switch result {
            case .success(let loginResult):
                self?.service.socialLogin(accessToken: loginResult.accessToken.value,
                                          type: .line) { [weak self] _result in
                    switch _result {
                    case .success(_):
                        self?.fetchRequiredData()
                        //                        self?.output?.obtainedSuccess()
                    case .failure(let err):
                        self?.output?.obtained(err)
                    }
                }
            case .failure(let error):
                //self?.output?.obtained(error)
                self?.output?.hideLoading()
                if error.errorCode != 3003 {
                    self?.output?.obtained(NSError(domain: "login-error", code: error.errorCode, userInfo: [NSLocalizedDescriptionKey:  LocalizedKey.loginFail.value]))
                }
            }
        }
    }
    
    func signupWithFacebook() {
        output?.showLoading()
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.email, .publicProfile], viewController: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_, _, let token):
                if let accessToken = token?.tokenString {
                    self.output?.showLoading()
                    self.service.socialLogin(accessToken: accessToken,
                                             type: .facebook) { [weak self] result in
                        switch result {
                        case .success(_):
                            self?.fetchRequiredData()
                        case .failure(let err):
                            self?.output?.obtained(err)
                        }
                    }
                }
            case .cancelled:
                self.output?.hideLoading()
            case .failed(let error):
                print(error.localizedDescription)
                self.output?.obtained(NSError(domain: "login-error", code: error._code, userInfo: [NSLocalizedDescriptionKey:  LocalizedKey.loginFail.value]))
            }
        }
    }
    
    func login(with username: String?, and password: String?) {
        guard let username = username, let password = password else {
            output?.obtained(EK_GlobalConstants.Error.oops)
            return
        }
        if username.isEmpty {
            output?.obtained(NSError(domain: "username-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.emailRequired.value]))
        }
        else if password.isEmpty {
            output?.obtained(NSError(domain: "password-error", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.passwordRequired.value]))
        } else {
            if NetworkReachabilityManager()?.isReachable == true {
                service.login(email: username, password: password) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.fetchRequiredData()
                    case .failure(let error):
                        self?.output?.obtained(error)
                        print("USER_LOGINERROR_\(error.localizedDescription)")
                    }
                }
            } else {
                output?.obtained(GlobalConstants.Error.noInternet)
            }
        }
    }
    
    private func fetchRequiredData() {
        service.registerFCM { _ in }
        output?.obtainedSuccess()
    }
}
