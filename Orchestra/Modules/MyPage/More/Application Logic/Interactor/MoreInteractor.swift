//
//  MoreInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class MoreInteractor {
    
	// MARK: Properties
    weak var output: MoreInteractorOutput?
    private let service: MoreServiceType
    
    // MARK: Initialization
    init(service: MoreServiceType) {
        self.service = service
    }

    // MARK: Converting entities
    
}

// MARK: More interactor input interface
extension MoreInteractor: MoreInteractorInput {
    
}
