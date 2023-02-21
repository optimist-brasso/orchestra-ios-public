//
//  SettingsServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//



protocol SettingsServiceType: AnyObject, NotificationStatusApi, LoggedInProtocol {
    
    var profile: Profile? { get }
    
}
