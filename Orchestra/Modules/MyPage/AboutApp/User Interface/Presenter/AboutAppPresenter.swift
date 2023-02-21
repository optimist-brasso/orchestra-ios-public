//
//  AboutAppPresenter.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 6/21/22.
//
//

import Foundation

class AboutAppPresenter {
    
	// MARK: Properties
    weak var view: AboutAppViewInterface?
    var interactor: AboutAppInteractorInput?
    var wireframe: AboutAppWireframeInput?

    // MARK: Converting entities
}

 // MARK: AboutApp module interface
extension AboutAppPresenter: AboutAppModuleInterface {
    
    func termServiceBtnTapped() {
        wireframe?.openWebView(title: LocalizedKey.termsOfService.value, url: GlobalConstants.URL.termsOfService)
    }
    
    func privacyButtonTapped() {
        wireframe?.openWebView(title: LocalizedKey.privacyPolicy.value, url: GlobalConstants.URL.privacyPolicy)
    }
    
    func notationButtonTapped() {
        wireframe?.openWebView(title: LocalizedKey.notation.value, url: GlobalConstants.URL.notation)
    }
    
    func softwareLicButtonTapped() {
        wireframe?.openWebView(title: LocalizedKey.softwareLiscence.value, url: GlobalConstants.URL.softwareLiscence)
    }
    
    func musicLicButtonTapped() {
//        wireframe?.openWebView(title: LocalizedKey.songLiscence.value, url: GlobalConstants.URL.songLiscence)
    }
    
    func reviewRatingButtonTapped() {
//        wireframe?.openWebView(title: LocalizedKey.reviewRating.value, url: GlobalConstants.URL.reviewRating)
    }
    
}

// MARK: AboutApp interactor output interface

extension AboutAppPresenter: AboutAppInteractorOutput {
    
}
