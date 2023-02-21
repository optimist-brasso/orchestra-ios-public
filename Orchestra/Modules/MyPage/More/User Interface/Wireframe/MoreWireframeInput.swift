//
//  MoreWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//



protocol MoreWireframeInput: WireframeInput {
    
    func openOnboarding()
    func navigateToAboutApp()
    func navigateToFAQ()
    func navigateToOpinionRequest()
    func navigateToOfficialSite()
    func openWebView(title: String?, url: String?)
    
}
