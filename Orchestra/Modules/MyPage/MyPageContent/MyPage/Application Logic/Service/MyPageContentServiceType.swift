//
//  MyPageContentServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//



protocol MyPageContentServiceType: AnyObject, LoggedInProtocol, UnregisterFCMApi {
    
    func clearDatabase()
    
}
