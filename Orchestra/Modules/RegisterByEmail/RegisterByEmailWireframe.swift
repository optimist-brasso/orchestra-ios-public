//
//  RegisterByEmailWireframe.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation

class RegisterByEmailWireframe: BaseWireframe {
    
    override init() {
        super.init()
    }
    
    
    override func setViewController() {
        let screen = RegisterByEmailScreen()
        let presenter = RegisterByEmailPresenter()
        
        view = RegisterByEmailController(screen: screen, presenter: presenter)
        
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
    
    override func handleTrigger(trigger: AppRoutable) {
        super.handleTrigger(trigger: trigger)
        switch trigger {
        case .otp:
            openOTP()
        default:
            break
        }
    }
    
    private func openOTP() {
        let wireframe = OneTimePasswordWireframe()
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    
}
