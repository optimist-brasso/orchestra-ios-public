//
//  AppendixVideoDetailWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

protocol AppendixVideoDetailWireframeInput: WireframeInput {
    
    var orchestraId: Int? { get set }
    var musicianId: Int? { get set }
    var instrumentId: Int? { get set }
    
    func openNotification()
    func openPreviousModule()
    func openCart()
    func openLogin()
    func openImageViewer(with imageUrl: String?)
    func openVideoPlayer()
//    func openVR()
    func openBuy(for type: SessionType)
    
}
