//
//  CheckoutConfirmationWireframeInput.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/06/2022.
//
//

protocol CheckoutConfirmationWireframeInput: WireframeInput {
    
    func openPreviousModule()
    var orchestraType: OrchestraType { get set }
    var ids: [Int]? { get set }
    
}
