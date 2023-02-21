//
//  EditProfileWireframe.swift
//  Orchestra
//
//  Created by manjil on 04/04/2022.
//

import Foundation
import UIKit

class EditProfileWireframe: BaseWireframe {
    
    let profile: ProfileStructure?
    let email: String?
    let password: String?
    let showBackButton: Bool
    
    init(profile: ProfileStructure? = nil, email: String? = nil, password: String? = nil, showBackButton: Bool) {
        self.profile = profile
        self.email = email
        self.password = password
        self.showBackButton = showBackButton
        super.init()
    }
    
    override func setViewController() {
        let screen = EditProfileScreen()
        let presenter = EditProfilePresenter(profile: profile)
        presenter.email = email
        presenter.password = password
        
       let  view = EditProfileController(screen: screen, presenter: presenter)
        view.showBackbutton = showBackButton
        self.view = view
        presenter.trigger.receive(on: RunLoop.main).subscribe(on: RunLoop.main).sink { [weak self] trigger in
            guard let self  = self else { return }
            self.handleTrigger(trigger: trigger)
        }.store(in: &bag)
    }
    
//    override func handleTrigger(trigger: AppRoutable) {
//        super.handleTrigger(trigger: trigger)
//        switch trigger {
//        case .login:
//            openLogin()
//        default:
//            break
//        }
//    }
    
//    private func openLogin() {
//        let login = UserLoginWireframe()
//        childWireframe = login
//        view.navigationController?.setViewControllers([login.view], animated: true)
//    }
    
    func openMainView(source: UIViewController) {
        let mainView = getMainView()
        let nav = BaseNavigationController(rootViewController: mainView)
        nav.modalPresentationStyle = .fullScreen
        source.present(nav, animated: true, completion: nil)
    }
    
}
