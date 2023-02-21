//
//  SearchViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

protocol SearchViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [SearchViewModel], isSession: Bool, isReload: Bool)
    func show(_ session: SearchViewModel)
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func endRefreshing()
    func show(hasMoreData: Bool)
    func show(_ error: Error)
    
}
