//
//  SignupWireframe.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//

import UIKit


class SignupWireframe {
     weak var view: UIViewController!
}

extension SignupWireframe: SignupWireframeInput {
    
    var storyboardName: String {return "Signup"}
    
    func getMainView() -> UIViewController {
        let service = SignupService()
        let interactor = SignupInteractor(service: service)
        let presenter = SignupPresenter()
        let viewController = viewControllerFromStoryboard(of: SignupViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
}
