//
//  CartServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//
//

import Foundation

protocol CartServiceType: AnyObject, CartListApi, DeleteCartItemApi, CheckoutApi, NotificationApi {
    
    var notificationCount: Int { get }
    
}
