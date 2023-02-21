//
//  BulkInstrumentPurchaseWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/06/2022.
//
//

protocol BulkInstrumentPurchaseWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    var instrumentId: Int?  { get set }
    var musicianId: Int?  { get set }
    var bulkType: SessionType {get set}
    func openConfirmation()
    func openPreviousModule()
    func openNotification()
    func openCart()
    func openSuccessView()
    
}
