//
//  BulkInstrumentBuyConfirmationViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/06/2022.
//
//

protocol BulkInstrumentBuyConfirmationViewInterface: AnyObject, BaseViewInterface {
    
    func show(title: String?, japaneseTitle: String?)
    func show(_ buySuccess: Bool, total: String)
    func show(_ error: Error)
    
}
