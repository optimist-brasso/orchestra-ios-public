//
//  InstrumentDetailBuyWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentDetailBuyWireframeInput: WireframeInput {
    
    var orchestraId: Int? { get set }
    var type: SessionType? { get set }
    func openPreviousModule()
    
}
