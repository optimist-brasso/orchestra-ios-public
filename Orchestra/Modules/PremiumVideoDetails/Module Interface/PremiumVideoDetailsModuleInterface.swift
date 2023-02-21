//
//  PremiumVideoDetailsModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//

protocol PremiumVideoDetailsModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func previousModule()
    func cart()
    func notification()
    func login()
    func addToCart(type: SessionType)
    func imageViewer(with imageUrl: String?)
    func vr()
    func bulkPurchase()
    func download()
    func cancelDownload()
    func favourite()
    func appendixVideo()
    
}
