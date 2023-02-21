//
//  ConductorDetailWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//



protocol ConductorDetailWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    func openNotification()
    func openListing()
    func openImageViewer(with imageUrl: String?)
    func openOrchestraDetails(as type: OrchestraType)
    func openLogin(for mode: OpenMode?)
    func openCart()
    func openVR()
    
}
