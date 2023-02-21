//
//  PlayerWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//



protocol PlayerWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    func openNotification()
    func openListing()
    func openLogin(for mode: OpenMode?)
    func openWebsite(of url: String?)
    func openCart()
    func openIntrumentDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?, isMinusOne:Bool?)
    func openConductorDetail(of id: Int?)
    
}
