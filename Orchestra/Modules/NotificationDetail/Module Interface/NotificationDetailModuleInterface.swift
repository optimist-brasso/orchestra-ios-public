//
//  NotificationDetailModuleInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

protocol NotificationDetailModuleInterface: AnyObject {
    
    func viewIsReady()
    func listing()
    func cart()
    func notification()
    func login(for mode: OpenMode?)
    
}
