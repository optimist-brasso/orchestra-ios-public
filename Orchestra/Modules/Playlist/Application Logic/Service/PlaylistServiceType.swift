//
//  PlaylistServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/04/2022.
//
//

import Foundation


protocol PlaylistServiceType: AnyObject, LoggedInProtocol, OrchestraListApi, OrchestraFavouriteApi, SearchApi, NotificationApi, SessionListApi, SessionFavouriteApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
