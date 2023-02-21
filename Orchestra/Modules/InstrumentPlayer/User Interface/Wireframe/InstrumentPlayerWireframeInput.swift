//
//  InstrumentPlayerWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//

protocol InstrumentPlayerWireframeInput: WireframeInput {
    
    var sessionType: SessionType { get set }
    var orchestraId: Int? { get set }
    var isAppendixVideo: Bool { get set }
    func openInstrumentPlayerPopup()
    func openPreviousModule()
    
}
