//
//  FAQPresenter.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import Foundation

class FAQPresenter {
    
	// MARK: Properties
    weak var view: FAQViewInterface?
    var interactor: FAQInteractorInput?
    var wireframe: FAQWireframeInput?

}

 // MARK: FAQ module interface
extension FAQPresenter: FAQModuleInterface {
    
    func contactUsButtonTapped() {
        wireframe?.openWebView(title: LocalizedKey.contactUs.value, url: GlobalConstants.URL.contactUs)
    }
    
    func frequentAskButtonTapped() {
        wireframe?.openWebView(title: LocalizedKey.faq.value, url: GlobalConstants.URL.faq)
    }
    
}

// MARK: FAQ interactor output interface
extension FAQPresenter: FAQInteractorOutput {
    
}
