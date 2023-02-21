//
//  OpinionRequestPresenter.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/22/22.
//
//

import Foundation

class OpinionRequestPresenter {
    
	// MARK: Properties
    weak var view: OpinionRequestViewInterface?
    var interactor: OpinionRequestInteractorInput?
    var wireframe: OpinionRequestWireframeInput?

    // MARK: Converting entities
}

 // MARK: OpinionRequest module interface
extension OpinionRequestPresenter: OpinionRequestModuleInterface {
    
    func requestButtonTapped() {
        wireframe?.openWebView(title: LocalizedKey.opinionRequestHere.value, url: GlobalConstants.URL.opinionRequest)
    }
    
}

// MARK: OpinionRequest interactor output interface
extension OpinionRequestPresenter: OpinionRequestInteractorOutput {
    
}
