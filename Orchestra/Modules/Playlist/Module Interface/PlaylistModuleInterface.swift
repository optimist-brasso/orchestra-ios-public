//
//  PlaylistModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

protocol PlaylistModuleInterface: AnyObject {
    
    func viewIsReady()
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, type: OrchestraType)
    func notification()
    func cart()
    func login(for mode: OpenMode?)
    func orchestraDetail(of id: Int?, type: OrchestraType)
    func instrumentDetail(of id: Int?, orchestraId: Int?, musicianId: Int?)
    func favourite(of id: Int?, instrumentId: Int?, musicianId: Int?, type: OrchestraType)
    func search(for keyword: String, type: OrchestraType)
    
}
