//
//  OrchestraListingServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 07/04/2022.
//
//



protocol OrchestraListingServiceType: AnyObject, OrchestraListApi, LoggedInProtocol, SearchApi, NotificationApi, PointListApi, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
