//
//  NotificationModuleInterface.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

import Combine

protocol NotificationModuleInterface: AnyObject {
    
    func viewIsReady(withLoading: Bool)
    var  list: CurrentValueSubject<[NotificationViewModel], Never> { get set}
    func homeListing(of type: OrchestraType)
    func notificationDetail(of index: Int)
    func cart()
    func login()
    
}
