//
//  RegisterPasswordWireframe.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import Combine

class RegisterPasswordWireframe: BaseWireframe {
    
    override init() {
        super.init()
    }
    
    override func setViewController() {
        let screen = RegisterByEmailScreen()
        let presenter = RegisterPasswordPresenter()
        view = RegisterPasswordController(screen: screen, presenter: presenter)
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
    
    override func handleTrigger(trigger: AppRoutable) {
        super.handleTrigger(trigger: trigger)
        switch trigger {
        case .updateProfile(let password):
            let wireframe = EditProfileWireframe(profile: nil, password: password, showBackButton: false)
            childWireframe = wireframe
            wireframe.pushMainView(on: view)
        default:
            break
        }
    }
    
}
