//
//  ProfileWireframe.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

import UIKit

class ProfileWireframe: BaseWireframe {
    override var storyboardName: String { get {return "Profile"} set {} }
    
    override func setViewController() {
        let service = ProfileService()
        let interactor = ProfileInteractor(service: service)
        let presenter = ProfilePresenter()
        let screen = ProfileScreen()
        let viewController = ProfileViewController(baseScreen: screen)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
    }
  
}

extension ProfileWireframe: ProfileWireframeInput {
    
    func openEditProfile(profile: ProfileStructure?) {
        let wireframe = EditProfileWireframe(profile: profile, showBackButton: true)
        childWireframe = wireframe
       //
        wireframe.openMainView(source: view)
    }

}
