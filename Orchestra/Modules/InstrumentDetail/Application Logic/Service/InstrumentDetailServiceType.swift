//
//  InstrumentDetailServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/13/22.
//
//

protocol InstrumentDetailServiceType: AnyObject, LoggedInProtocol, InstrumentDetailApi, SessionFavouriteApi {
    
    var notificationCount: Int { get }
    var cartCount: Int { get }
    func fetchVrPath(of fileName: String?) -> String?
    
}
