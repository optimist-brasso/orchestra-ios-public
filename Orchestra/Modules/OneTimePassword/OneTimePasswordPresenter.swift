//
//  OneTimePasswordPresenter.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import Combine
import Alamofire

class OneTimePasswordPresenter: BasePresenter {
    
    let otp = TextModel(dataType: .otp, interactor: TextInteractor(type: PlainFieldType.otp, pattern: Pattern.none))
    
    var error: [AppError] = []
    
    let response = PassthroughSubject<Response, Never>()
    
    let userManager = UserManager()
    override init() {
        super.init()
        observeEvent()
    }
    
    private func observeEvent() {
        otp.$error.sink { [weak self] error in
            self?.error = [error].compactMap { $0 }
        }.store(in: &bag)
    }
    
    func callApi() {
        var parameters = ["token": otp.value.trim]
        if let email = Cacher().get(String.self, forKey: .email) {
            parameters["email"] = email
        }
        let router = AuthRouter.tokenVerification(parameters)
        if NetworkReachabilityManager()?.isReachable == true {
            userManager.request(type:SendToken.self, router: router).sink { [weak self] result in
                let message = result.success ? result.object?.data?.detail ??  "" : result.error.description
                self?.response.send((result.success, message, router))
            }.store(in: &bag)
        } else {
            response.send((false, GlobalConstants.Error.noInternet.localizedDescription, router))
        }
    }
    
    func callResendApi(email: String) {
        let router = AuthRouter.resendActivationCode(["email": email])
        if NetworkReachabilityManager()?.isReachable == true {
            userManager.request(type:SendToken.self, router: router).sink { [weak self] result in
                let message = result.success ? result.object?.data?.detail ??  "" : result.error.description
                self?.response.send((result.success, message, router))
            }.store(in: &bag)
        } else {
            response.send((false, GlobalConstants.Error.noInternet.localizedDescription, router))
        }
    }
    
}
