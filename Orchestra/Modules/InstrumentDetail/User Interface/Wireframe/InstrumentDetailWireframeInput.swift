//
//  InstrumentDetailWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

protocol InstrumentDetailWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    var orchestraId: Int? { get set }
    var musicianId: Int? { get set }
    func openPreviousModule()
    func openBulkPurchase()
    func openBuy()
    func openCart()
    func openNotification()
    func openPremiumVideo()
    func openLogin()
    func openOrchestraDetails(as type: OrchestraType)
    func openImageViewer(with imageUrl: String?)
    func openVR()
    func openAppendixVideo()
    
}
