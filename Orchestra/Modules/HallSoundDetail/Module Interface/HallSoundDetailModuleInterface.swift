//
//  HallSoundDetailModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//

protocol HallSoundDetailModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    func notification()
    func listing()
    func buy()
    func favourite()
    func login(for mode: OpenMode?)
    func orchestraDetail(as type: OrchestraType)
    func cart()
    func download()
    func download(of index: Int)
    func cancelDownload()
    
}
