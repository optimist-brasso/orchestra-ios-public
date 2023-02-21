//
//  NotificationDetailWireframeInput.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//



protocol NotificationDetailWireframeInput: WireframeInput {
    
    var isNotificationDetail: Bool { get set }
    var id: Int? { get set }
    func openListing()
    func openCart()
    func openLogin(for mode: OpenMode?)
    func openNotification()
    
}
