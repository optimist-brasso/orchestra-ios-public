//
//  PremiumVideoDetailsWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol PremiumVideoDetailsWireframeInput: WireframeInput {
    
    var orchestraId: Int? { get set }
    var musicianId: Int?  {get set}
    var instrumentId: Int? {get set}
    func openPreviousModule()
    func openNotification()
    func openCart()
    func openLogin()
    func openBuy(for type: SessionType)
    func openImageViewer(with imageUrl: String?)
    func openBulkPurchase()
    func openVR()
    func openAppendixVideo()
    
}
