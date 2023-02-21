//
//  NotificationViewInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//



protocol NotificationViewInterface: AnyObject, BaseViewInterface {
    
    func showLoginNeed()
    func show(_ cartCount: Int)
    func endRefreshing()
    func show(_ error: Error)
    
}
