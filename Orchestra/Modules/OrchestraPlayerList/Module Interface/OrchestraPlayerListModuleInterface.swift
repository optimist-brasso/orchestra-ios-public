//
//  OrchestraPlayerListModuleInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

protocol OrchestraPlayerListModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool, isRefreshed: Bool)
    func notification()
    func details(of id: Int?)
    func cart()
    func login(for mode: OpenMode?)
    
}
