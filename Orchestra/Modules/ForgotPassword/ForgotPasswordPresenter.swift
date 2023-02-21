//
//  ForgotPasswordPresenter.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import Foundation
import Combine
import Alamofire

class ForgotPasswordPresenter: BasePresenter {
    
    let email = TextModel(dataType: .email, interactor: TextInteractor(type: PlainFieldType.email, pattern: Pattern.email))
    var error: [AppError] = []
    let response = PassthroughSubject<(String, Bool), Never>()
    
    let  service: ForgotPasswordService
    
    init(service: ForgotPasswordService) {
        self.service = service
        super.init()
        observeEvent()
    }
    
    private func observeEvent() {
        email.$error.sink { [weak self] error in
            self?.error = [error].compactMap { $0 }
        }.store(in: &bag)
    }
    
    func callApi()  {
        if NetworkReachabilityManager()?.isReachable == true {
            service.forgotPassword(email: email.value.trim) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let msg):
                    self.response.send((msg, true))
                case .failure(let error):
                    self.response.send((error.localizedDescription, false))
                }
            }
        } else {
            response.send((GlobalConstants.Error.noInternet.localizedDescription, false))
        }
    }
    
}
