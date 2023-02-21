//
//  OnboardingInteractor.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 05/04/2022.
//
//

import Foundation

class OnboardingInteractor {
    
	// MARK: Properties
    
    weak var output: OnboardingInteractorOutput?
    private let service: OnboardingServiceType
    
    // MARK: Initialization
    
    init(service: OnboardingServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: Onboarding interactor input interface

extension OnboardingInteractor: OnboardingInteractorInput {
    
}
