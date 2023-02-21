//
//  PlaylistViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

protocol PlaylistViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [PlaylistViewModel], isSession: Bool, reload: Bool)
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func endRefreshing()
    func show(hasMoreData: Bool)
    func show(_ error: Error)
    
}
