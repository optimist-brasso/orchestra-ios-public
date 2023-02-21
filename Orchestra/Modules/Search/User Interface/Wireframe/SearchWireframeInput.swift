//
//  SearchWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//



protocol SearchWireframeInput: WireframeInput {
    
    func openNotification()
    func openCart()
    func openLogin(for mode: OpenMode?)
    func openOrchestraDetail(of id: Int?, type: OrchestraType)
    func openInstrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?)
    
}
