//
//  Instrument.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import Foundation

class Instrument: Codable {
    
    var id: Int?
    var name: String?
    var musician: Musician?
    var vrFile: String?
    var vrThumbnail: String?
    var premiumVrFile: String?
    var premiumVrThumbnail: String?
    var appendixFile: String?
    var appendixThumbnail: String?
    var premiumContent: String?
    var premiumDescription: String?
    var description: String?
    var orchestra: Orchestra?
    var partPrice: Double?
    var partIdentifier: String?
    var isPartBought: Bool = false
    var premiumPrice: Double?
    var premiumIdentifier: String?
    var isPremiumBought: Bool = false
    var comboPrice: Double?
    var comboIdentifier: String?
    var isSelected = false
    var partVRPath: String?
    var premiumVRPath: String?
    var appendixVRPath: String?
    var isFavourite: Bool = false
    var leftViewAngle: Int?
    var rightViewAngle: Int?
    
    enum CodingKeys: String, CodingKey {
        case id,
             name,
             musician = "player",
             vrFile = "ios_vr_file",
             vrThumbnail = "vr_thumbnail",
             premiumVrFile = "ios_premium_vr_file",
             premiumVrThumbnail = "premium_vr_thumbnail",
             appendixFile = "premimum_file",
             appendixThumbnail = "premium_thumbnail",
             premiumContent = "premium_contents",
             premiumDescription = "premium_video_description",
             description,
             orchestra,
             partPrice = "part_price",
             partIdentifier = "part_identifier",
             isPartBought = "is_part_bought",
             premiumPrice = "premium_video_price",
             premiumIdentifier = "premium_video_identifier",
             isPremiumBought = "is_premium_bought",
             comboPrice = "combo_price",
             comboIdentifier = "combo_identifier",
             isFavourite = "is_favourite",
             leftViewAngle = "left_view_angle",
             rightViewAngle = "right_view_angle"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int?.self, forKey: .id) ?? nil
        name = try container.decodeIfPresent(String?.self, forKey: .name) ?? nil
        musician = try container.decodeIfPresent(Musician?.self, forKey: .musician) ?? nil
        vrFile = try container.decodeIfPresent(String?.self, forKey: .vrFile) ?? nil
        vrThumbnail = try container.decodeIfPresent(String?.self, forKey: .vrThumbnail) ?? nil
        premiumVrFile = try container.decodeIfPresent(String?.self, forKey: .premiumVrFile) ?? nil
        premiumVrThumbnail = try container.decodeIfPresent(String?.self, forKey: .premiumVrThumbnail) ?? nil
        appendixFile = try container.decodeIfPresent(String?.self, forKey: .appendixFile) ?? nil
        appendixThumbnail = try container.decodeIfPresent(String?.self, forKey: .appendixThumbnail) ?? nil
        premiumContent = try container.decodeIfPresent(String?.self, forKey: .premiumContent) ?? nil
        premiumDescription = try container.decodeIfPresent(String?.self, forKey: .premiumDescription) ?? nil
        description = try container.decodeIfPresent(String?.self, forKey: .description) ?? nil
        orchestra = try container.decodeIfPresent(Orchestra?.self, forKey: .orchestra) ?? nil
        partPrice = try container.decodeIfPresent(Double?.self, forKey: .partPrice) ?? nil
        partIdentifier = try container.decodeIfPresent(String?.self, forKey: .partIdentifier) ?? nil
        isPartBought = try container.decodeIfPresent(Bool.self, forKey: .isPartBought) ?? false
        premiumPrice = try container.decodeIfPresent(Double?.self, forKey: .premiumPrice) ?? nil
        premiumIdentifier = try container.decodeIfPresent(String?.self, forKey: .premiumIdentifier) ?? nil
        isPremiumBought = try container.decodeIfPresent(Bool.self, forKey: .isPremiumBought) ?? false
        comboPrice = try container.decodeIfPresent(Double?.self, forKey: .comboPrice) ?? nil
        comboIdentifier = try container.decodeIfPresent(String?.self, forKey: .comboIdentifier) ?? nil
        isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
        leftViewAngle = try container.decodeIfPresent(Int?.self, forKey: .leftViewAngle) ?? nil
        rightViewAngle = try container.decodeIfPresent(Int?.self, forKey: .rightViewAngle) ?? nil
    }
    
    func getCartItem(of type: SessionType) -> CartItem {
        let item = CartItem()
        if let orchestraId = orchestra?.id,
           let musicianId = musician?.id,
           let cartItem: CartItem = DatabaseHandler.shared.fetch(filter: "orchestraId == \(orchestraId) AND orchestraType == 'session' AND sessionType == '\(type.rawValue)' AND musicianId == \(musicianId)").first {
            item.id = cartItem.id
        }
        item.orchestraType = OrchestraType.session.rawValue
        item.sessionType = type.rawValue
        item.orchestraId = orchestra?.id
        item.musicianId = musician?.id
        item.instrumentId = id
        
        switch type {
        case .part:
            item.price = partPrice ?? .zero
        case .premium:
            item.price = premiumPrice ?? .zero
        case .combo:
            item.price = comboPrice ?? .zero
        default: break
        }
        return item
    }
    
    var cartItems: [CartItem]? {
        if let orchestraId = orchestra?.id,
           let musicianId = musician?.id {
            let cartItems: [CartItem] = DatabaseHandler.shared.fetch(filter: "orchestraId == \(orchestraId) AND orchestraType == 'session' AND musicianId == \(musicianId)")
            return cartItems
        }
        return nil
    }
    
    func fetchDownloadedMedia(of type: SessionType) -> DownloadedMedia {
        var fileURL: String? {
            switch type {
            case .part:
                return vrFile
            case .premium:
                return premiumVrFile
            case .appendix:
                return appendixFile
            default:
                return nil
            }
        }
        if let fileName = fileURL?.fileName,
           let realmModel: DownloadedMediaRealmModel = DownloadManager.shared.fetchDownloadedMedia(of: fileName) {
            let model = realmModel.normalModel
            if model.path?.isEmpty ?? true,
               DownloadManager.shared.persistedVideos[model.url ?? ""] == nil {
                model.url = fileURL
                DispatchQueue.main.async {
                    DatabaseHandler.shared.update {
                        realmModel.url = fileURL
                    }
                    DatabaseHandler.shared.writeObjects(with: [model.realmModel])
                }
            }
            return model
        }
        let media = DownloadedMedia()
        media.id = Int(Date().timeIntervalSince1970)
        media.url = fileURL
        media.fileName = fileURL?.fileName
        return media
    }
    
//    func getDownloadedMedia(of type: SessionType, isTrailer: Bool = false) -> DownloadedMedia {
//        if let orchestraId = orchestra?.id,
//           let musicianId = musician?.id,
//           let realmModel: DownloadedMediaRealmModel = DownloadManager.shared.getDownloadedMedia(orchestraId: orchestraId, type: .session, sessionType: type, musicianId: musicianId) {
//            let model = realmModel.normalModel
//            if model.path?.isEmpty ?? true,
//               DownloadManager.shared.persistedVideos[model.url ?? ""] == nil {
//                model.url = type == .part ? vrFile : premiumFile
//                DispatchQueue.main.async {
//                    DatabaseHandler.shared.update { [weak self] in
//                        realmModel.url = type == .part ? self?.vrFile : self?.premiumFile
//                    }
//                    DatabaseHandler.shared.writeObjects(with: [model.realmModel])
//                }
//            }
//            return model
//        }
//        let media = DownloadedMedia()
//        media.id = Int(Date().timeIntervalSince1970)
////        media.orchestraId = orchestra?.id
////        media.type = OrchestraType.session.rawValue
////        media.sessionType = type.rawValue
////        media.musicianId = player?.id
//        media.url = type == .part ? vrFile : premiumFile
//        return media
//    }

//    var cartItem: CartItem {
//        let item = CartItem()
//        item.id = id
//        item.orchestraType = OrchestraType.session.rawValue
//        item.orchestraId = orchestra?.id
//        item.musicianId = player?.id
//        return item
//    }
    
    init() {}
    
}
