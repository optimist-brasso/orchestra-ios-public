//
//  record_playerPresenter.swift
//  Orchestra
//
//  Created by rohit lama on 11/05/2022.
//
//

import Foundation

class record_playerPresenter {
    
	// MARK: Properties
    
    weak var view: record_playerViewInterface?
    var interactor: record_playerInteractorInput?
    var wireframe: record_playerWireframeInput?

    // MARK: Converting entities
}

 // MARK: record_player module interface

extension record_playerPresenter: record_playerModuleInterface {
    
}

// MARK: record_player interactor output interface

extension record_playerPresenter: record_playerInteractorOutput {
    
}
