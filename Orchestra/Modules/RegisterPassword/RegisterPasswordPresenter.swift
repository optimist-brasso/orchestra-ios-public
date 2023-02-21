//
//  RegisterPasswordPresenter.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import Combine

class RegisterPasswordPresenter: BasePresenter, RegisterPasswordApi {
    
    let password = TextModel(dataType: .password, interactor: TextInteractor(type: PlainFieldType.password, pattern: Pattern.password))
    
    var error: [AppError] = []
    let response = PassthroughSubject<(String, Bool), Never>()
    
    override init() {
        super.init()
        observeEvent()
    }
    
    private func observeEvent() {
        password.$error.sink { [weak self] error in
            self?.error = [error].compactMap { $0 }
        }.store(in: &bag)
    }
    
    func register() {
        let email = Cacher().get(String.self, forKey: .email) ?? ""
        register(email: email, password: password.value) { [weak self] result in
            switch result {
            case .success((let model)):
                self?.response.send((model.detail ?? "", true))
            case .failure(let error):
                self?.response.send((error.localizedDescription, false))
            }
        }
    }
    
}
