//
//  InstrumentPlayerViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 14/06/2022.
//
//



protocol InstrumentPlayerViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: InstrumentPlayerViewModel)
    func audioFileUploaded()
    func endLoading()
    func show(_ error: Error)
    
}
