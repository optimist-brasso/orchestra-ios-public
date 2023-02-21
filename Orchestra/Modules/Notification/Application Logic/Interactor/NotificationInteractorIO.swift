//
//  NotificationInteractorIO.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//

protocol NotificationInteractorInput: AnyObject {
    
    func getNotification(completion: @escaping (Result<[PushNotification], Error>) -> Void)
    func getLoginStatus()
    func read(of id: Int?)

}

protocol NotificationInteractorOutput: AnyObject {
    
    func obtainedLoginStatus(_ status: Bool)
    func obtained(_ cartCount: Int)
    
}
