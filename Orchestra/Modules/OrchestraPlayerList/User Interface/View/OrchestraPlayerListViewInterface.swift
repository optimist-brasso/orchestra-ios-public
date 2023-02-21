//
//  OrchestraPlayerListViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

protocol OrchestraPlayerListViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ modele: [OrchestraPlayerListViewModel])
    func endRefreshing()
    func show(_ hasMoreData: Bool)
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ error: Error)
    
}
