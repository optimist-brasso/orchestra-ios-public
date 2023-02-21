//
//  FavouriteServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/04/2022.
//
//

import Foundation


protocol FavouriteServiceType: AnyObject, FavouriteApi, NotificationApi, SessionFavouriteListApi, SessionFavouriteApi, OrchestraFavouriteApi, PlayerFavouriteApi {
  //  func getFavouriteList(completion:  (Result<Favourite, Error>) -> Void)
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
