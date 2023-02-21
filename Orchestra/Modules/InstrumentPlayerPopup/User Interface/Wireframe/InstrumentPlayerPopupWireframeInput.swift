//
//  InstrumentPlayerPopupWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentPlayerPopupWireframeInput: WireframeInput {
    
    var sessionType: SessionType { get set }
    var orchestraId: Int? { get set }
    var isAppendixVideo: Bool { get set }
    func openPreviousModule()
    func openBulkPurchase()
    func openPremiumVideoPlayer()
    func openAppendixVideoPlayer()
    
}
