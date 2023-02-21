//
//  OrchestraPlayerListServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

import Foundation

protocol OrchestraPlayerListServiceType: AnyObject, OrchestraPlayerListApi, LoggedInProtocol {
    
    var cartCount: Int { get }
    var notificationCount: Int { get }
    
}
