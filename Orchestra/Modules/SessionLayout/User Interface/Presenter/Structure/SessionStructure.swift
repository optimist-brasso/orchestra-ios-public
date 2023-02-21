//
//  SessionStructure.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 02/06/2022.
//

import Foundation
import CoreGraphics

struct SessionStructure {
    
    var image: String?
    var layouts: [SessionLayoutStructure]?
    
}

struct SessionLayoutStructure {
    
    var x: CGFloat
    var y: CGFloat
    var height: CGFloat
    var width: CGFloat
    var instrument: SessionLayoutInstrumentStructure?
    
}

struct SessionLayoutInstrumentStructure {
    
    var id: Int?
    var name: String?
    var musicianId: Int?
    var player: String?
    var playerImage: String?
    var description: String?
    var isBought: Bool?
    
}
