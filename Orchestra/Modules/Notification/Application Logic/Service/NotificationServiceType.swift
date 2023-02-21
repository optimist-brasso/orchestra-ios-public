//
//  NotificationServiceType.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//



protocol NotificationServiceType: AnyObject, NotificationApi, LoggedInProtocol, NotificationDetailApi {
    
    var cartCount: Int { get }
    func read(of id: Int?)
    
}
