//
//  RegisterByEmailPresenter.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import Combine
import Alamofire

typealias Response = (success: Bool, message: String, router: Routable)
class RegisterByEmailPresenter: BasePresenter {
    
    let email = TextModel(dataType: .email, interactor: TextInteractor(type: PlainFieldType.email, pattern: Pattern.email))
    
    var error: [AppError] = []
    
    let response = PassthroughSubject<Response, Never>()
    
    let userManager: UserManager
    
    override init() {
        userManager = UserManager()
        super.init()
        getEmail()
        observeEvent()
    }
    
    func getEmail() {
        let email =  Cacher().get(String.self, forKey: .email) ?? ""
        self.email.value = email
    }
    
    private func observeEvent() {
        email.$error.sink { [weak self] error in
            self?.error = [error].compactMap { $0 }
        }.store(in: &bag)
        
        //        userManager.networkingResult.sink { [weak self] result in
        //            guard let self = self else { return }
        //            let message = result.success ? result.object?.detail ??  "" : result.error.description
        //            self.response.send((result.success, message))
        //        }.store(in: &bag)
    }
    
    func callApi() {
        if NetworkReachabilityManager()?.isReachable == true {
            userManager.request(type: SendToken.self, router: AuthRouter.sendActivationToken(["email": email.value.trim])).sink { [weak self] result in
                guard let self = self else { return }
                let message = result.success ? result.object?.data?.detail ??  "" : result.error.description
                self.response.send((result.success, message, AuthRouter.sendActivationToken([:])))
            }.store(in: &bag)
        } else {
            response.send((false, GlobalConstants.Error.noInternet.localizedDescription, AuthRouter.sendActivationToken([:])))
        }
    }
}
