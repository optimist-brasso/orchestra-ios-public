//
//  HomeServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 06/04/2022.
//
//



protocol HomeServiceType: AnyObject, HomeApi, LoggedInProtocol, NotificationApi, PointListApi, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
