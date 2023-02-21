//
//  ResetPasswordWireframe.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import Foundation
import Combine


final class ResetPasswordWireframe: BaseWireframe  {
    
    let email: String
    init(email: String) {
        self.email = email
        super.init()
    }
    
    override func setViewController() {
        let screen = ResetPasswordScreen()
        let presenter = ResetPasswordPresenter(service: ResetPasswordService(), email: email)
        
        view = ResetPasswordController(screen: screen, presenter: presenter)
        
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
}

