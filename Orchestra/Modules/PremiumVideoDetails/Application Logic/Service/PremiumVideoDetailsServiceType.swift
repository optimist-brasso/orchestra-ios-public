//
//  PremiumVideoDetailsServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/06/2022.
//
//


protocol PremiumVideoDetailsServiceType: AnyObject, LoggedInProtocol, OrchestraFavouriteApi, SessionFavouriteApi, InstrumentDetailApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    func fetchVrPath(of fileName: String?) -> String? 
    
}
