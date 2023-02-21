//
//  InstrumentDetailModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

protocol InstrumentDetailModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func previousModule()
    func bulkPurchase()
    func buy()
    func notification()
    func cart()
    func premiumVideo()
    func login()
    func orchestraDetails(as type: OrchestraType)
    func imageViewer(with imageUrl: String?)
    func vr()
    func downloadVideo()
    func cancelDownload()
    func favourite()
    func appendixVideo()
    
}
