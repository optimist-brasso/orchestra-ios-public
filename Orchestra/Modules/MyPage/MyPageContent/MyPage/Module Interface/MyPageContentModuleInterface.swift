//
//  MyPageContentModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol MyPageContentModuleInterface: AnyObject {
    
    func viewIsReady()
    func profile()
    func purchasedContentList()
    func recordingList()
    func logout()
    func login()
    func openChangePassword()
    func openBillingHistory()
    func withdraw()
    func buyPoint()
    
}
