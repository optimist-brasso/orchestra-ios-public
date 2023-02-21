//
//  AppendixVideoDetailModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//

protocol AppendixVideoDetailModuleInterface: AnyObject {
    
//    func getDataFromApi()
    func viewIsReady(withLoading: Bool)
    func cart()
    func notification()
    func previousModule()
    func login()
    func imageViewer(with imageUrl: String?)
    func videoPlayer()
    func download()
    func cancelDownload()
//    func vr()
    func addToCart(type: SessionType)
    func favourite()
    
}
