//
//  SessionLayoutWireframeInput.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

protocol SessionLayoutWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    func openInstrumentDetails(of id: Int?, musicianId: Int?)
    func openPreviousModule()
    func openLogin(for mode: OpenMode?)
    func openMusicianDetail(of id: Int)
    
}
