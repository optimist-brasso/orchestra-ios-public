//
//  PlayerListingServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol PlayerListingServiceType: AnyObject, PlayerListApi, LoggedInProtocol, NotificationApi,  PointListApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
