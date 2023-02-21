//
//  OrchestraListingWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol OrchestraListingWireframeInput: WireframeInput {
    
    var pageOption: OrchestraType? { get set }
    func openOrchestraListing(of type: OrchestraType)
    func openNotification()
    func openOrchestraDetail(of id: Int?)
    func openCart()
    func openLogin(for mode: OpenMode?)
    
}
