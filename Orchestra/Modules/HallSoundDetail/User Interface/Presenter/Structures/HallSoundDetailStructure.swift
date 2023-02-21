//
//  HallSoundDetailStructure.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import Foundation

struct HallSoundDetailStructure {
    
    var title: String?
    var titleJapanese: String?
    var description: String?
    var composer: String?
    var band: String?
    var conductor: String?
    var organization: String?
    var venue: String?
    var venueDescription: String?
    var duration: String?
    var releaseDate: String?
    var liscenceNumber: String?
    var isFavourite: Bool?
    var isBought: Bool
    var image: String?
    var businessType: String?
    var hallsounds: [HallSoundDetailAudioStrcture]?
//    var leftFloor: HallSoundDetailAudioStrcture?
//    var rightFloor: HallSoundDetailAudioStrcture?
//    var centerFloor: HallSoundDetailAudioStrcture?
//    var backFloor: HallSoundDetailAudioStrcture?
    var isDownloaded: Bool?
    
}

struct HallSoundDetailAudioStrcture {
    
    var image: String?
    var audioLink: String?
    var type: String?
    var position: Int?
    
}
