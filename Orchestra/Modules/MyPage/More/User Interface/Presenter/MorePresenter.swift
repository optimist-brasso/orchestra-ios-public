//
//  MorePresenter.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class MorePresenter {
    
	// MARK: Properties
    weak var view: MoreViewInterface?
    var interactor: MoreInteractorInput?
    var wireframe: MoreWireframeInput?

    // MARK: Converting entities
    
}

 // MARK: More module interface
extension MorePresenter: MoreModuleInterface {
    
    func onboarding() {
        wireframe?.openOnboarding()
    }
    
    func navigateToAboutApp() {
        wireframe?.navigateToAboutApp()
    }
    
    func navigateToFAQ() {
        wireframe?.navigateToFAQ()
    }
    
    func navigateToOpinionRequest() {
        wireframe?.navigateToOpinionRequest()
    }
    
    func navigateToOfficialSite() {
//        wireframe?.navigateToOfficialSite()
        wireframe?.openWebView(title: "Brasso", url: GlobalConstants.URL.website)
    }
    
    func webView(title: String?, url: String?) {
        wireframe?.openWebView(title: title, url: url)
    }
    
}

// MARK: More interactor output interface
extension MorePresenter: MoreInteractorOutput {
    
}
