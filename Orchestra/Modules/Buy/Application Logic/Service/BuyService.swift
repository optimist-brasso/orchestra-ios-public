//
//  BuyService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//

import Foundation

class BuyService: BuyServiceType {
    
    func fetchHallSoundCartItem(of id: Int) -> CartItem? {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch(filter: "orchestraId == \(id) AND orchestraType == 'hall_sound'")
        return cartItems.first
    }
    
}
