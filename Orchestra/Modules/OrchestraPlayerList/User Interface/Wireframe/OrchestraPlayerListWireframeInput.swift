//
//  OrchestraPlayerListWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//
//

protocol OrchestraPlayerListWireframeInput: WireframeInput {
    
    var id: Int? { get set }
    func openNotification()
    func openDetails(of id: Int?)
    func openCart()
    func openLogin(for mode: OpenMode?)
    
}
