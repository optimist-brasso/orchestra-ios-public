//
//  ConductorDetailServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//
//

import Foundation


protocol ConductorDetailServiceType: AnyObject, OrchestraDetailApi, OrchestraFavouriteApi, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
//    func savePath(of id: Int, path: String)
//    func fetchOrchestra(of id: Int) -> Orchestra?
    func fetchVrPath(of fileName: String?) -> String?
    
}
