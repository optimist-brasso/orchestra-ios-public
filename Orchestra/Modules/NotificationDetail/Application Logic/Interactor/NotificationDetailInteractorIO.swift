//
//  NotificationDetailInteractorIO.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

protocol NotificationDetailInteractorInput: AnyObject {
    
    func getData()
    func getLoginStatus()

}

protocol NotificationDetailInteractorOutput: AnyObject {

    func obtained(_ model: NotificationDetailStructure)
    func obtainedLoginStatus(_ status: Bool)
    func obtained(cartCount: Int)
    func obtained(_ error: Error)
    func obtained(notificationCount: Int)
    
}
