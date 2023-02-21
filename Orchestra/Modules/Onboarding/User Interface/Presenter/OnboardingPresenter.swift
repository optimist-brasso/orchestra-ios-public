//
//  OnboardingPresenter.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 05/04/2022.
//
//

import Foundation

class OnboardingPresenter {
    
	// MARK: Properties
    weak var view: OnboardingViewInterface?
    var interactor: OnboardingInteractorInput?
    var wireframe: OnboardingWireframeInput?

}

 // MARK: Onboarding module interface
extension OnboardingPresenter: OnboardingModuleInterface {
    
    func gotoLoginPage() {
        wireframe?.openLoginPage()
    }
    
}

// MARK: Onboarding interactor output interface
extension OnboardingPresenter: OnboardingInteractorOutput {
    
}
