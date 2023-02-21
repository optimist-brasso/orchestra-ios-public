//
//  FAQInteractor.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import Foundation

class FAQInteractor {
    
	// MARK: Properties
    
    weak var output: FAQInteractorOutput?
    private let service: FAQServiceType
    
    // MARK: Initialization
    
    init(service: FAQServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: FAQ interactor input interface

extension FAQInteractor: FAQInteractorInput {
    
}
