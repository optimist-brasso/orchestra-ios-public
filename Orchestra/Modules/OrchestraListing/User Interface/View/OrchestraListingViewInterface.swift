//
//  OrchestraListingViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol OrchestraListingViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: [OrchestraListingViewModel])
    func show(point: PointHistory?)
    func endRefreshing()
    func showLoginNeed(for mode: OpenMode?)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ error: Error)
    
}
