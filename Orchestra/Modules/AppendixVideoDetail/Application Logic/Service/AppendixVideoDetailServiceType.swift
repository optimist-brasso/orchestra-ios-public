//
//  AppendixVideoDetailServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/08/2022.
//
//



protocol AppendixVideoDetailServiceType: AnyObject, LoggedInProtocol, SessionFavouriteApi, InstrumentDetailApi {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    func fetchVrPath(of fileName: String?) -> String? 
    
}
