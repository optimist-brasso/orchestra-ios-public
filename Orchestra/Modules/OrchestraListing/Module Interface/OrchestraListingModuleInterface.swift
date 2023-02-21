//
//  OrchestraModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//

protocol OrchestraListingModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool)
    func orchestraListing(of type: OrchestraType)
    func notification()
    func search(for keyword: String)
    func orchestraDetail(of id: Int?)
    func cart()
    func login(for mode: OpenMode?)
    
}
