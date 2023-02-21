//
//  OfficialSiteInteractor.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/23/22.
//
//

import Foundation

class OfficialSiteInteractor {
    
	// MARK: Properties
    
    weak var output: OfficialSiteInteractorOutput?
    private let service: OfficialSiteServiceType
    
    // MARK: Initialization
    
    init(service: OfficialSiteServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: OfficialSite interactor input interface

extension OfficialSiteInteractor: OfficialSiteInteractorInput {
    
}
