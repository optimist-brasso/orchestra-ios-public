//
//  MoreModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol MoreModuleInterface: AnyObject {
    
    func onboarding()
    func navigateToAboutApp()
    func navigateToFAQ()
    func navigateToOpinionRequest()
    func navigateToOfficialSite()
    func webView(title: String?, url: String?)
    
}
