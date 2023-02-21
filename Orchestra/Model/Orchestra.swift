//
//  Orchestra.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import Foundation

class Orchestra: Codable {
    
    var id: Int?
    var title: String?
    var titleJapanese: String?
    var description: String?
    var composer: String?
    var conductor: String?
    var venueTitle: String?
    var venueDescription: String?
    var duration: Int?
    var releaseDate: String?
    var image: String?
    var tags: [String]?
    var organization: String?
    var businessType: String?
    var band: String?
    var liscenceNumber: String?
    var organizationDiagram: String?
    var isConductorFavourite: Bool = false
    var isSessionFavourite: Bool = false
    var isHallSoundFavourite: Bool = false
    var type: String?
    var isFavourite: Bool = false
    var isHallSoundBought: Bool?
    var hallsounds: [HallSound]?
    var isPremium: Bool?
    var vrFile: String?
    var iOSVrFile: String?
    var vrPath: String?
    var vrThumbnail: String?
    var instrumentName: String?
    var hallsoundPrice: Double?
    var hallsoundIdentifier: String?
    var leftViewAngle: Int?
    var rightViewAngle: Int?
    var isBought: Bool = false
    var playDuration: Int?
    var venueDiagram: String?
    var conductorImage: String?
    var sessionImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             titleJapanese = "title_jp",
             description = "introduction",
             composer,
             conductor,
             venueTitle = "venue_title",
             venueDescription = "venue_description",
             duration,
             releaseDate = "release_date",
             image,
             tags,
             organization,
             businessType = "business_type",
             band = "band",
             liscenceNumber = "jasrac_license_number",
             organizationDiagram = "organization_diagram",
             isConductorFavourite = "is_conductor_favourite",
             isSessionFavourite = "is_session_favourite",
             isHallSoundFavourite = "is_hallsound_favourite",
             type,
             isFavourite = "is_favourite",
             isHallSoundBought = "is_hallsound_buy",
             hallsounds = "hall_sound",
             isPremium = "is_premium",
             vrFile = "ios_vr_file",
             iOSVrFile = "vr_file",
             vrPath = "vr_path",
             vrThumbnail = "vr_thumbnail",
             instrumentName = "instrument_name",
             hallsoundPrice = "hall_sound_price",
             hallsoundIdentifier = "hall_sound_identifier",
             leftViewAngle = "left_view_angle",
             rightViewAngle = "right_view_angle",
             isBought = "is_bought",
             playDuration = "play_duration",
             venueDiagram = "venue_diagram",
        conductorImage = "conductor_image",
        sessionImage = "session_image"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        title = try container.decodeIfPresent(String?.self, forKey: .title) ?? nil
        titleJapanese = try container.decodeIfPresent(String?.self, forKey: .titleJapanese) ?? nil
        description = try container.decodeIfPresent(String?.self, forKey: .description) ?? nil
        composer = try container.decodeIfPresent(String?.self, forKey: .composer) ?? nil
        conductor = try container.decodeIfPresent(String?.self, forKey: .conductor) ?? nil
        venueTitle = try container.decodeIfPresent(String?.self, forKey: .venueTitle) ?? nil
        venueDescription = try container.decodeIfPresent(String?.self, forKey: .venueDescription) ?? nil
        duration = try container.decodeIfPresent(Int?.self, forKey: .duration) ?? nil
        releaseDate = try container.decodeIfPresent(String?.self, forKey: .releaseDate) ?? nil
        image = try container.decodeIfPresent(String?.self, forKey: .image) ?? nil
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? nil
        organization = try container.decodeIfPresent(String?.self, forKey: .organization) ?? nil
        businessType = try container.decodeIfPresent(String?.self, forKey: .businessType) ?? nil
        band = try container.decodeIfPresent(String?.self, forKey: .band) ?? nil
        liscenceNumber = try container.decodeIfPresent(String?.self, forKey: .liscenceNumber) ?? nil
        organizationDiagram = try container.decodeIfPresent(String?.self, forKey: .organizationDiagram) ?? nil
        isConductorFavourite = try container.decodeIfPresent(Bool.self, forKey: .isConductorFavourite) ?? false
        isSessionFavourite = try container.decodeIfPresent(Bool.self, forKey: .isSessionFavourite) ?? false
        isHallSoundFavourite = try container.decodeIfPresent(Bool.self, forKey: .isHallSoundFavourite) ?? false
        type = try container.decodeIfPresent(String?.self, forKey: .type) ?? nil
        isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
        isHallSoundBought = try container.decodeIfPresent(Bool?.self, forKey: .isHallSoundBought) ?? false
        hallsounds = try container.decodeIfPresent([HallSound].self, forKey: .hallsounds) ?? nil
        vrFile = try container.decodeIfPresent(String?.self, forKey: .vrFile) ?? nil
        iOSVrFile = try container.decodeIfPresent(String?.self, forKey: .iOSVrFile) ?? nil
        vrThumbnail = try container.decodeIfPresent(String?.self, forKey: .vrThumbnail) ?? nil
        hallsoundPrice = try container.decodeIfPresent(Double?.self, forKey: .hallsoundPrice) ?? nil
        hallsoundIdentifier = try container.decodeIfPresent(String?.self, forKey: .hallsoundIdentifier) ?? nil
        venueDiagram = try container.decodeIfPresent(String?.self, forKey: .venueDiagram) ?? nil
        conductorImage = try container.decodeIfPresent(String?.self, forKey: .conductorImage) ?? nil
        sessionImage = try container.decodeIfPresent(String?.self, forKey: .sessionImage) ?? nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(titleJapanese, forKey: .titleJapanese)
        try container.encode(duration, forKey: .duration)
        try container.encode(businessType, forKey: .businessType)
        try container.encode(vrFile, forKey: .vrFile)
        try container.encode(vrPath, forKey: .vrPath)
        try container.encode(instrumentName, forKey: .instrumentName)
        try container.encode(leftViewAngle, forKey: .leftViewAngle)
        try container.encode(rightViewAngle, forKey: .rightViewAngle)
        try container.encode(isBought, forKey: .isBought)
        try container.encode(playDuration, forKey: .playDuration)
        try container.encode(isPremium, forKey: .isPremium)
    }
    
    func fetchDownloadedMedia(of type: OrchestraType, index: Int? = nil) -> [DownloadedMedia] {
        switch type {
        case .conductor:
            if let fileName = vrFile?.fileName, let realmModel: DownloadedMediaRealmModel = DownloadManager.shared.fetchDownloadedMedia(of: fileName) {
                let model = realmModel.normalModel
                if model.path?.isEmpty ?? true,
                   DownloadManager.shared.persistedVideos[model.url ?? ""] == nil {
                    model.url = self.vrFile
                    DispatchQueue.main.async {
                        DatabaseHandler.shared.update { [weak self] in
                            realmModel.url = self?.vrFile
                        }
                        DatabaseHandler.shared.writeObjects(with: [model.realmModel])
                    }
                }
                return [model]
            }
        case .hallSound:
            if let index = index {
                var medias = [DownloadedMedia]()
                if let hallsound = hallsounds?.element(at: index) {
                    if let fileName = hallsound.fileLink?.fileName,
                       let realmModel: DownloadedMediaRealmModel = DownloadManager.shared.fetchDownloadedMedia(of: fileName) {
                        let model = realmModel.normalModel
                        if model.path?.isEmpty ?? true,
                           DownloadManager.shared.persistedVideos[model.url ?? ""] == nil {
                            model.url = hallsound.fileLink
                            DispatchQueue.main.async {
                                DatabaseHandler.shared.update {
                                    realmModel.url = model.url
                                }
                                DatabaseHandler.shared.writeObjects(with: [model.realmModel])
                            }
                        }
                        medias.append(model)
                    } else {
                        let media = DownloadedMedia()
                        media.id = Int(Date().timeIntervalSince1970)
                        media.url = hallsound.fileLink
                        media.fileName = hallsound.fileLink?.fileName
                        medias.append(media)
                    }
                    if !medias.isEmpty {
                        return medias
                    }
                }
            }
            var medias = [DownloadedMedia]()
            hallsounds?.enumerated().forEach({
                if let fileName = $0.element.fileLink?.fileName,
                   let realmModel: DownloadedMediaRealmModel = DownloadManager.shared.fetchDownloadedMedia(of: fileName) {
                    let model = realmModel.normalModel
                    if model.path?.isEmpty ?? true,
                       DownloadManager.shared.persistedVideos[model.url ?? ""] == nil {
                        model.url = $0.element.fileLink
                        DispatchQueue.main.async {
                            DatabaseHandler.shared.update {
                                realmModel.url = model.url
                            }
                            DatabaseHandler.shared.writeObjects(with: [model.realmModel])
                        }
                    }
                    medias.append(model)
                } else {
                    let media = DownloadedMedia()
                    media.id = Int(Date().timeIntervalSince1970) + $0.offset
                    media.url = $0.element.fileLink
                    media.fileName = $0.element.fileLink?.fileName
                    medias.append(media)
                }
            })
            if !medias.isEmpty {
                return medias
            }
        default: break
        }
        var medias = [DownloadedMedia]()
        switch type {
        case .conductor:
            let media = DownloadedMedia()
            media.id = Int(Date().timeIntervalSince1970)
            media.url = vrFile
            media.fileName = vrFile?.fileName
            medias.append(media)
        case .hallSound:
            hallsounds?.forEach({
                let media = DownloadedMedia()
                media.id = Int(Date().timeIntervalSince1970)
                media.url = $0.fileLink
                media.fileName = $0.fileLink?.fileName
                medias.append(media)
            })
        default: break
        }
        return medias
    }
    
    init() {}
    
}

protocol Purchasable: Codable {
    var id: Int? { get set }
    var title: String { get set }
    var titleJapanese: String { get set } //title_jp
    var releaseDate: String { get set }
    var image: String { get set }
    var duration: Int { get set }
    var tag: [String] { get set }
    var venueDiagram:String { get set }
    var sessionImage:String { get set }
}
struct Purchased: Codable {
    
    var hallSound: [PurchasedHallSound]
    var conductor: [PurchasedConductor]
    var part: [PurchasedPart]
    var premium: [PurchasedPremium]
    
    
    enum CodingKeys: String, CodingKey {
        case hallSound = "hall_sound"
        case conductor
        case part
        case premium
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hallSound = try container.decodeIfPresent([PurchasedHallSound].self, forKey: .hallSound) ?? []
        conductor = try container.decodeIfPresent([PurchasedConductor].self, forKey: .conductor) ?? []
        part = try container.decodeIfPresent([PurchasedPart].self, forKey: .part) ?? []
        premium = try container.decodeIfPresent([PurchasedPremium].self, forKey: .premium) ?? []
    }
    
}

struct PurchasedHallSound: Purchasable {

    var id: Int?
    var title: String
    var titleJapanese: String
    var releaseDate: String
    var image: String
    var duration: Int
    var tag: [String]
    var venueDiagram: String
    var sessionImage: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese = "title_jp"
        case releaseDate = "release_date"
        case image
        case duration
        case tag
        case venueDiagram = "venue_diagram"
        case sessionImage = "session_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        titleJapanese =  try container.decodeIfPresent(String.self, forKey: .titleJapanese) ?? ""
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        tag = try container.decodeIfPresent([String].self, forKey: .tag) ?? []
        venueDiagram = try container.decodeIfPresent(String.self, forKey: .venueDiagram) ?? ""
        sessionImage = try container.decodeIfPresent(String.self, forKey: .sessionImage) ?? ""
        
    }
    
}

struct PurchasedConductor: Purchasable {
    var id: Int?
    var title: String
    var titleJapanese: String
    var releaseDate: String
    var image: String
    var duration: Int
    var tag: [String]
    var venueDiagram: String
    var sessionImage: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese = "title_jp"
        case releaseDate = "release_date"
        case image
        case duration
        case tag
        case venueDiagram = "venue_diagram"
        case sessionImage = "session_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        titleJapanese =  try container.decodeIfPresent(String.self, forKey: .titleJapanese) ?? ""
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        tag = try container.decodeIfPresent([String].self, forKey: .tag) ?? []
        venueDiagram = try container.decodeIfPresent(String.self, forKey: .venueDiagram) ?? ""
        sessionImage = try container.decodeIfPresent(String.self, forKey: .sessionImage) ?? ""
        
    }
    
}

struct PurchasedPart: Purchasable {
    var id: Int?
    var title: String
    var titleJapanese: String
    var releaseDate: String
    var image: String
    var duration: Int
    var tag: [String]
    var instrumentId: Int? //instrument_id
    var instrumentTitle: String   //instrument_title
    var musicianId:Int? // musician_id
    var venueDiagram:String
    var sessionImage:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese = "title_jp"
        case releaseDate = "release_date"
        case image
        case duration
        case tag
        case instrumentId = "instrument_id"
        case instrumentTitle = "instrument_title"
        case musicianId =  "musician_id"
        case venueDiagram = "venue_diagram"
        case sessionImage = "session_image"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        titleJapanese =  try container.decodeIfPresent(String.self, forKey: .titleJapanese) ?? ""
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        tag = try container.decodeIfPresent([String].self, forKey: .tag) ?? []
        instrumentId = try container.decodeIfPresent(Int.self, forKey: .instrumentId)
        instrumentTitle = try container.decodeIfPresent(String.self, forKey: .instrumentTitle) ?? ""
        musicianId = try container.decodeIfPresent(Int.self, forKey: .musicianId)
        venueDiagram = try container.decodeIfPresent(String.self, forKey: .venueDiagram) ?? ""
        sessionImage = try container.decodeIfPresent(String.self, forKey: .sessionImage) ?? ""
    }
}

struct PurchasedPremium: Purchasable {
    var id: Int?
    var title: String
    var titleJapanese: String
    var releaseDate: String
    var image: String
    var duration: Int
    var tag: [String]
    var instrumentId: Int? //instrument_id
    var instrumentTitle: String   //instrument_title
    var musicianId:Int? // musician_id
    var venueDiagram:String
    var sessionImage:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese = "title_jp"
        case releaseDate = "release_date"
        case image
        case duration
        case tag
        case instrumentId = "instrument_id"
        case instrumentTitle = "instrument_title"
        case musicianId =  "musician_id"
        case venueDiagram = "venue_diagram"
        case sessionImage = "session_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        titleJapanese =  try container.decodeIfPresent(String.self, forKey: .titleJapanese) ?? ""
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        tag = try container.decodeIfPresent([String].self, forKey: .tag) ?? []
        instrumentId = try container.decodeIfPresent(Int.self, forKey: .instrumentId)
        instrumentTitle = try container.decodeIfPresent(String.self, forKey: .instrumentTitle) ?? ""
        musicianId = try container.decodeIfPresent(Int.self, forKey: .musicianId)
        venueDiagram = try container.decodeIfPresent(String.self, forKey: .venueDiagram) ?? ""
        sessionImage = try container.decodeIfPresent(String.self, forKey: .sessionImage) ?? ""
    }
}
