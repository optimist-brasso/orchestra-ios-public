//
//  OfficialSitePresenter.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL 6/23/22.
//
//

import Foundation

class OfficialSitePresenter {
    
	// MARK: Properties
    
    weak var view: OfficialSiteViewInterface?
    var interactor: OfficialSiteInteractorInput?
    var wireframe: OfficialSiteWireframeInput?

    // MARK: Converting entities
}

 // MARK: OfficialSite module interface

extension OfficialSitePresenter: OfficialSiteModuleInterface {
    func twitterButtonTapped() {
        
    }
    
    func lineButtonTapped() {
        
    }
    
    func facebookButtonTapped() {
        
    }
    
    func youtubeButtonTapped() {
        
    }
    
    
}

// MARK: OfficialSite interactor output interface

extension OfficialSitePresenter: OfficialSiteInteractorOutput {
    
}
