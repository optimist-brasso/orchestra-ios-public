//
//  ChangePasswordPresenter.swift
//  Orchestra
//
//  Created by manjil on 15/04/2022.
//

import Foundation
import Combine

class ChangePasswordPresenter: BasePresenter {
    
    let  service: ChangePasswordService
    
    let oldPassword = TextModel(dataType: .oldPassword, interactor: TextInteractor(type: PlainFieldType.oldPassword, pattern: Pattern.none))
    let newPassword = TextModel(dataType: .newPassword, interactor: TextInteractor(type: PlainFieldType.newPassword, pattern: Pattern.password))
    let confirmPassword = TextModel(dataType: .confirmPassword, interactor: TextInteractor(type: PlainFieldType.confirmPassword, pattern: Pattern.none))
    var error: [AppError]  = []
    
    init(service: ChangePasswordService) {
        self.service = service
        super.init()
        observeEvent()
    }
    
    func observeEvent() {
        Publishers.CombineLatest3(oldPassword.$error, newPassword.$error, confirmPassword.$error).sink { [weak self] old, new, confirm in
            self?.error = [old, new, confirm].compactMap { $0 }
        }.store(in: &bag)
    }
    
}
