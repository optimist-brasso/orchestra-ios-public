//
//  SplashServiceType.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import Foundation

protocol SplashServiceType: AnyObject, LoggedInProtocol, ProfileApi, CartListApi, NotificationApi, ReadNotificationApi {
    
    var readNotificationIds: [Int]? { get }
    var unreadNotificationCount: Int? { get }
    
}
