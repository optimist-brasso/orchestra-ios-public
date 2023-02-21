//
//  OpenMode.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 5/3/22.
//

import Foundation

enum OpenMode {
    
    case buy(tab: TabBarIndex = .home,
             type: OrchestraType,
             id: Int,
             instrumentId: Int? = nil,
             musicianId: Int? = nil),
         cart(tab: TabBarIndex = .home),
         bulkBuy,
         addToCart(type: SessionType),
         session(id: Int?, musicianId: Int?),
         favourite(tab: TabBarIndex = .home,
                   type: OrchestraType,
                   id: Int,
                   instrumentId: Int? = nil,
                   musicianId: Int? = nil,
                   detailNavigation: Bool = false),
         instrumentDetail(tab: TabBarIndex = .home,
                          id: Int?,
                          instrumentId: Int?,
                          musicianId: Int?)
    
}

enum TabBarIndex: Int {
    
case home,
    point,
    playlist,
    favourite,
    myPage
    
}
