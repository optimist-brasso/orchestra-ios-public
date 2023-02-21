//
//  WithdrawConfirmationService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//
//

import Foundation

class WithdrawConfirmationService: WithdrawConfirmationServiceType {
    
    func clearDatabase() {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        DatabaseHandler.shared.delete(object: cartItems)
    }
    
}
