//
//  BuyWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//



protocol BuyWireframeInput: WireframeInput {
    
    var orchestraType: OrchestraType { get set }
    var id: Int? { get set }
    func openPreviousModule()
    func openLogin()
    
}
