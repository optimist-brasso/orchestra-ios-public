//
//  ForgotPasswordWireframe.swift
//  Orchestra
//
//  Created by manjil on 18/04/2022.
//

import Foundation


class ForgotPasswordWireframe: BaseWireframe {
    
    
    override func setViewController() {
        let screen = RegisterByEmailScreen()
        let presenter = ForgotPasswordPresenter(service: ForgotPasswordService())
        
        view = ForgotPasswordController(screen: screen, presenter: presenter)
        
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
    
    
    override func handleTrigger(trigger: AppRoutable) {
        super.handleTrigger(trigger: trigger)
        
        switch trigger {

        case .resetPassword(let email):
            openResetPassword(email: email)
        default: break
        }
    }
    
    private func openResetPassword(email: String) {
        let wireframe = ResetPasswordWireframe(email: email)
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
}
