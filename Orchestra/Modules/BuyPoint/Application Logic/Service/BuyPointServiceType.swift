//
//  BuyPointServiceType.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//
//

import Foundation

protocol BuyPointServiceType: PointListApi, ProfileApi, MyPageServiceType {
    
    var points: Int { get }
    
}
