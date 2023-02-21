//
//  NotificationWireframeInput.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 07/04/2022.
//
//



protocol NotificationWireframeInput: WireframeInput {
    
    func openHomeListing(of type: OrchestraType)
    func openNotificationDetail()
    func openLogin()
    func openCart()
    
}
