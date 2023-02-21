//
//  PurchasedContentListModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

protocol PurchasedContentListModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func search(for keyword: String)
    func openConductor(id: Int)
    func openHallSound(id: Int)
    func openPartDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?)
    func openPremiumDetail(instrumentId: Int?, orchestraId: Int?, musicianId: Int?)
}
