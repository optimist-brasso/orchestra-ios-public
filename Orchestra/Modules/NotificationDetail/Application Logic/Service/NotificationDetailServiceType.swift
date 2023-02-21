//
//  NotificationDetailServiceType.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//



protocol NotificationDetailServiceType: AnyObject, LoggedInProtocol, NotificationDetailApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    func read(of id: Int?)
    
}
