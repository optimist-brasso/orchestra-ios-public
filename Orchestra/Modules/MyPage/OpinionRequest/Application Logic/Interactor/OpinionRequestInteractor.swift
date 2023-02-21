//
//  OpinionRequestInteractor.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/22/22.
//
//

import Foundation

class OpinionRequestInteractor {
    
	// MARK: Properties
    
    weak var output: OpinionRequestInteractorOutput?
    private let service: OpinionRequestServiceType
    
    // MARK: Initialization
    
    init(service: OpinionRequestServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: OpinionRequest interactor input interface

extension OpinionRequestInteractor: OpinionRequestInteractorInput {
    
}
