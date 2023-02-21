//
//  SearchServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//



protocol SearchServiceType: AnyObject, LoggedInProtocol, SearchApi, OrchestraFavouriteApi, NotificationApi, SessionListApi, SessionFavouriteApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
