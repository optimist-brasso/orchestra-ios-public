//
//  NotificationDetailViewInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

protocol NotificationDetailViewInterface: AnyObject, BaseViewInterface {
    
    func showLoginNeed(for mode: OpenMode?)
    func show(_ error: Error)
    func show(cartCount: Int)
    func show(_ model: NotificationDetailViewModel)
    func show(notificationCount: Int)
    
}
