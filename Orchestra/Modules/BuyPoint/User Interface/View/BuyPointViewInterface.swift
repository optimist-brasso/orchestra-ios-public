//
//  BuyPointViewInterface.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//



protocol BuyPointViewInterface: AnyObject, BaseViewInterface {
    
    func show(_ models: PointHistory)
    func endRefreshing()
    func show(points: String)
    func show(cartCount: Int)
    func show(notificationCount: Int)
    func show(_ error: Error)
    
}
