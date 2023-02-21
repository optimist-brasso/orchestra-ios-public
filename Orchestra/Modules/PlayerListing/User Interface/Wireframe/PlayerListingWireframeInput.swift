//
//  PlayerListingWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol PlayerListingWireframeInput: WireframeInput {
    
    func openOrchestraListing(of type: OrchestraType)
    func openNotification()
    func openDetails(of id: Int?)
    func openCart()
    func openLogin(for mode: OpenMode?)
    
}
