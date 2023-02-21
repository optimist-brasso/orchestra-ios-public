//
//  BuyServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/04/2022.
//
//



protocol BuyServiceType: AnyObject, AddToCartApi, CheckoutApi {
    
    func fetchHallSoundCartItem(of id: Int) -> CartItem?
    
}
