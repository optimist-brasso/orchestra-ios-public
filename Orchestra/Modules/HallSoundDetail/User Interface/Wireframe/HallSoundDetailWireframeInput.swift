//
//  HallSoundDetailWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//



protocol HallSoundDetailWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    func openNotification()
    func openListing()
    func openBuy()
    func openLogin(for mode: OpenMode?)
    func openOrchestraDetail(as type: OrchestraType)
    func openCart()
    
}
