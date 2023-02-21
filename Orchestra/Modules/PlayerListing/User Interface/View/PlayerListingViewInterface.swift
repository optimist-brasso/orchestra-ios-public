//
//  PlayerListingViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol PlayerListingViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ modele: [PlayerListingViewModel])
    func show(point: PointHistory?) 
    func show(_ hasMoreData: Bool)
    func endRefreshing()
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ error: Error)
    
}
