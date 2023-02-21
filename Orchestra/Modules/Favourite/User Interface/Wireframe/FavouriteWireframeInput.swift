//
//  FavouriteWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//



protocol FavouriteWireframeInput: WireframeInput {
    
    func openNotification()
    func openCart()
    func openDetails(of id: Int, type: OrchestraType)
    func openInstrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?)
    
}
