//
//  ChangePasswordWireframe.swift
//  Orchestra
//
//  Created by manjil on 15/04/2022.
//

import Foundation

class ChangePasswordWireframe: BaseWireframe {
    
    let service: ChangePasswordService
    
    init(service: ChangePasswordService) {
        self.service = service
        super.init()
    }
    
    override func setViewController() {
        let screen = ChangePasswordScreen()
        let presenter = ChangePasswordPresenter(service: service)
        
        view = ChangePasswordController(screen: screen, presenter: presenter)
        
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
}
