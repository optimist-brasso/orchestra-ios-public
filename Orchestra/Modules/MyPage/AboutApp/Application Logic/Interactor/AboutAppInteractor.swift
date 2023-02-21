//
//  AboutAppInteractor.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import Foundation

class AboutAppInteractor {
    
	// MARK: Properties
    
    weak var output: AboutAppInteractorOutput?
    private let service: AboutAppServiceType
    
    // MARK: Initialization
    
    init(service: AboutAppServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: AboutApp interactor input interface

extension AboutAppInteractor: AboutAppInteractorInput {
    
}
