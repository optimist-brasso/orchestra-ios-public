//
//  SessionLayoutViewInterface.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

protocol SessionLayoutViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: SessionViewModel)
    func showLoginNeed(for mode: OpenMode?)
    func show(_ error: Error)
//    func fetchedData(data: [InstrumentModel])

}
