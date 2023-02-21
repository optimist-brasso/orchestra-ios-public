//
//  ConductorDetailModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import Combine

protocol ConductorDetailModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func listing()
    func notification()
    func imageViewer(with imageUrl: String?)
    func orchestraDetails(as type: OrchestraType)
    func cart()
    func favourite()
    func login(for mode: OpenMode?)
    func vr()
    func downloadVideo()
    func cancelDownload()
    
}
