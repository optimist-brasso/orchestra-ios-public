//
//  MyPageContentService.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation

class MyPageContentService: MyPageContentServiceType {
    
    func clearDatabase() {
        let cartItems: [CartItem] = DatabaseHandler.shared.fetch()
        DatabaseHandler.shared.delete(object: cartItems)
        let profiles: [Profile] = DatabaseHandler.shared.fetch()
        DatabaseHandler.shared.delete(object: profiles)
    }
    
}
