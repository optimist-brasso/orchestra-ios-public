//
//  RegisterWireframe.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit
import Combine

class RegisterWireframe: BaseWireframe {
    
    override init() {
        super.init()
    }
    
    override func setViewController() {
        let screen = RegisterScreen()
        let presenter = RegistersPresenter()
        
        view = RegistersController(screen: screen, presenter: presenter)
        
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
    
    override func handleTrigger(trigger: AppRoutable) {
        super.handleTrigger(trigger: trigger)
        switch trigger {
        case .registerByEmail:
            openRegisterByEmail()
        case .splash:
            openSplash()
        case .login:
            openLogin()
        default:
            break
        }
    }
    
    private func openRegisterByEmail() {
        let wireframe = RegisterByEmailWireframe()
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    private func openLogin() {
        let wireframe = UserLoginWireframe()
        childWireframe = wireframe
        wireframe.pushMainView(on: view)
    }
    
    func openSplash() {
        let wireframe = SplashWireframe()
        childWireframe = wireframe
        view.view.window?.rootViewController = wireframe.getMainView()
    }
    
}
