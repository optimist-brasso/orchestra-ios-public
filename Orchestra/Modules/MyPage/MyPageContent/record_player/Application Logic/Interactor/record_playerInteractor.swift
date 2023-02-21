//
//  record_playerInteractor.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import Foundation

class record_playerInteractor {
    
	// MARK: Properties
    
    weak var output: record_playerInteractorOutput?
    private let service: record_playerServiceType
    
    // MARK: Initialization
    
    init(service: record_playerServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: record_player interactor input interface

extension record_playerInteractor: record_playerInteractorInput {
    
}
