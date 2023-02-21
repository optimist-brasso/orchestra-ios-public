//
//  PlayerListingModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

protocol PlayerListingModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool, keyword: String?)
    func homeListing(of type: OrchestraType)
    func notification()
    func details(of id: Int?)
    func cart()
    func login(for mode: OpenMode?)
    
}
