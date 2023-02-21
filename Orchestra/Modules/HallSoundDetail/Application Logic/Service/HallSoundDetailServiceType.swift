//
//  HallSoundDetailServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//
//



protocol HallSoundDetailServiceType: AnyObject, OrchestraDetailApi, OrchestraFavouriteApi, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    func fetchVrPath(of id: Int, type: String) -> String? 
    
}
