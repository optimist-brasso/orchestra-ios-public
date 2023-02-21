//
//  HallSoundDetailViewModel.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import Foundation

struct HallSoundDetailViewModel {
    
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
    var hallsounds: [HallSoundDetailAudioViewModel]?
//    var leftFloor: HallSoundDetailAudioViewModel?
//    var rightFloor: HallSoundDetailAudioViewModel?
//    var centerFloor: HallSoundDetailAudioViewModel?
//    var backFloor: HallSoundDetailAudioViewModel?
    var isDownloaded: Bool?
    
}

struct HallSoundDetailAudioViewModel {
    
    var image: String?
    var audioLink: String?
    var type: String?
    var position: Int?
    
}
