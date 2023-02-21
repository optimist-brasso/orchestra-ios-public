//
//  HomeWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//



protocol HomeWireframeInput: WireframeInput {
    
    func openHomeListing(of type: OrchestraType)
    func openNotification()
    func openBannerDetails(for url: String?)
    func openDetails(of id: Int?)
    func openCart()
    func openLogin(for mode: OpenMode?)
    
}
