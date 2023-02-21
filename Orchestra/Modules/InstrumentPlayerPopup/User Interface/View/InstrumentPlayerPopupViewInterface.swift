//
//  InstrumentPlayerPopupViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol InstrumentPlayerPopupViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: InstrumentPlayerPopupViewModel)
    func show(_ error: Error)
    
}
