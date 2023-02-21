//
//  BulkInstrumentBuyConfirmationWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

protocol BulkInstrumentBuyConfirmationWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    var type: SessionType {get set}
    var successState: Bool { get set }
    func openPreviousModule()
    
}
