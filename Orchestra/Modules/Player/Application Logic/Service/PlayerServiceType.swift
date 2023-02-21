//
//  PlayerServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//
//



protocol PlayerServiceType: AnyObject, PlayerDetailApi, PlayerFavouriteApi, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
