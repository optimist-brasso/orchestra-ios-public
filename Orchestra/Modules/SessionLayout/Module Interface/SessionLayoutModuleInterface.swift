//
//  SessionLayoutModuleInterface.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/4/22.
//
//

import CoreGraphics

protocol SessionLayoutModuleInterface: AnyObject {
    
    func viewIsReady(with navigationBarHeight: CGFloat?)
    func instrumentDetails(of id: Int?, musicianId: Int?)
    func previousModule()
    func login(for mode: OpenMode?)
    
}
