//
//  OnboardingWireframe.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 05/04/2022.
//
//

import UIKit


class OnboardingWireframe: BaseWireframe {
    override var storyboardName: String {
        set { }
        get {   "Onboarding" }
       }
   
    var openRegister: (() -> Void)?
    var isCancellable = false
    
    override func setViewController() {
        let service = OnboardingService()
        let interactor = OnboardingInteractor(service: service)
        let presenter = OnboardingPresenter()
        let viewController =  NewOnboardingController()  //viewControllerFromStoryboard(of: OnboardingViewController.self) //
        viewController.openRegister =  { [weak self] in
            self?.openRegister?()
        }
       // viewController.isCancellable = isCancellable
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
    }
    
    func openLoginPage() {
        self.window?.rootViewController = TabBarViewController()
    }
    
    init(isCancellable: Bool = false) {
        self.isCancellable = isCancellable
    }
    
}

extension OnboardingWireframe: OnboardingWireframeInput {

}
