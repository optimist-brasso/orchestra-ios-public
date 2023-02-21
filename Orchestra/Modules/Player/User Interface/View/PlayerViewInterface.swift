//
//  PlayerViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//



protocol PlayerViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ model: PlayerViewModel)
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func endRefreshing()
    func showFavouriteStatus(_ status: Bool)
    func show(_ error: Error)
    
}
