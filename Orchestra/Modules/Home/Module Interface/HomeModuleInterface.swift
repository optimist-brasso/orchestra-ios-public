//
//  HomeModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//

protocol HomeModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool)
    func homeListing(of type: OrchestraType)
    func notification()
    func bannerDetails(_ details: (url: String?, image: String?, title: String?, description: String?))
    func details(of id: Int?)
    func cart()
    func login(for mode: OpenMode?)
    
}
