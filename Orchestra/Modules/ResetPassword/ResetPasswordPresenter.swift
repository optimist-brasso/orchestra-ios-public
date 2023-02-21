//
//  ResetPasswordPresenter.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import Foundation
import Combine
import Alamofire

class ResetPasswordPresenter: BasePresenter {
    
    let otp = TextModel(dataType: .otp, interactor: TextInteractor(type: PlainFieldType.otp, pattern: Pattern.none))
    let password = TextModel(dataType: .newPassword, interactor: TextInteractor(type: PlainFieldType.newPassword, pattern: Pattern.password))
    
    var error: [AppError] = []
    let response = PassthroughSubject<(String, Bool), Never>()
    let service: ResetPasswordService
    let email: String
    
    init(service: ResetPasswordService, email: String) {
        self.email = email
        self.service = service
        super.init()
        observeEvent()
    }
    
    private func observeEvent() {
        Publishers.CombineLatest(otp.$error, password.$error).sink { [weak self] otp, password in
            guard let self = self else { return }
            self.error = [otp, password].compactMap { $0 }
        }.store(in: &bag)
    }
    
    func callApi() {
        if NetworkReachabilityManager()?.isReachable == true {
            service.resetPassword(email: email, token: otp.value, password: password.value, confirmPassword: password.value) { [weak self] result in
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
