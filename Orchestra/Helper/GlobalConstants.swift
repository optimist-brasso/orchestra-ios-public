//
//  GlobalConstants.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//

import UIKit

struct GlobalConstants {
    
    static let currency = "¥"
    static let sampleDuration = 30
    
    struct Image {
        
        static let profile = UIImage(named: "profile")
        static let settings = UIImage(named: "settings")
        static let more = UIImage(named: "more")
        static let rightArrow = UIImage(named: "right-arrow")
        static let leftArrow = UIImage(named: "left-arrow")
        static let filter = UIImage(named: "filter")
        static let moreAction = UIImage(named: "moreAction")
        static let group = UIImage(named: "group")
        static let logo = UIImage(named: "logo")
        static let cart = UIImage(named: "cart")
        static let notification = UIImage(named: "notification")
        static let borderedRightArrow = UIImage(named: "borderedRightArrow")
        static let play = UIImage(named: "play")
        static let leftArrowThin = UIImage(named: "leftArrowThin")
        static let rightArrowThin = UIImage(named: "rightArrowThin")
        static let edit = UIImage(named: "edit")
        static let favourite = UIImage(named: "favourite")
        static let placeholder = UIImage(named: "placeholder")
        static let share = UIImage(named: "share")
        static let download = UIImage(named: "download")
        static let stop = UIImage(named: "stop")
        static let filledPlay = UIImage(named: "filled_play")
        static let leftRoundedArrow = UIImage(named: "leftRoundedArrow")
        static let rightRoundedArrow = UIImage(named: "rightRoundedArrow")
        static let checkboxSelected = UIImage(named: "checkboxSelected")
        static let purchased = UIImage(named: "purchased")
        static let playerThumbnailLarge = UIImage(named: "player_thumbnail_large")
        static let playerThumbnailSmall = UIImage(named: "player_thumbnail_small")
        
        struct TabBar {
            static let home = UIImage(named: "home")
            static let search = UIImage(named: "search")
            static let music = UIImage(named: "music")
            static let favourite = UIImage(named: "favourite-empty")
            static let profile = UIImage(named: "profileSettings")
        }
        
    }
    
    struct Onboarding {
        
        static let sectionHeading = ["このアプリの使い方", "○○○○○○について", "○○○○○○について"]
        
        static let sectionSubHeading1 = ["説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。", "説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります","説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。"]
        
        static let sectionSubHeading2 = ["説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。", "説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。", "説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。説明がはいります。"]
        
        static let images = ["onboard", "onboard", "onboard"]
        
    }
    
    struct Notification {
        
        let name: String
        
        var notificationName: NSNotification.Name {
            return NSNotification.Name(rawValue: name)
        }
        
        func fire(withObject object: Any? = nil) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
        }

        static let didBuy = Notification(name: "didBuy")
        static let didAddToCart = Notification(name: "didBuy")
        static let getNotification = Notification(name: "getNotification")
        static let didReadNotification = Notification(name: "didReadNotification")
        static let getItemsToCheckout = Notification(name: "getItemsToCheckout")
        static let sendVRData = Notification(name: "sendVRData")
        static let openCart = Notification(name: "openCart")
        static let getCartItem = Notification(name: "getCartItem")
        static let getInstrument = Notification(name: "getInstrument")
        static let didUpdateFavouriteItem = Notification(name: "didUpdateFavouriteItem")
        static let getSessionLayout = Notification(name: "getSessionLayout")
        static let didUpdateFavourite = Notification(name: "didUpdateFavourite")
        static let didClearDownload = Notification(name: "didClearDownload")
        static let didEndRefreshContol = Notification(name: "didEndRefreshControl")
        
    }
    
    struct AspectRatio {
        
        static let sessionBackground: (width: CGFloat, height: CGFloat) = (500, 300)
        static let listImage: (width: CGFloat, height: CGFloat) = (83, 151)
        static let player: (width: CGFloat, height: CGFloat) = (130, 165)
        static let videoThumbnail: (width: CGFloat, height: CGFloat) = (390, 210)
        
    }
    
    struct Error {
        static let noInternet = NSError(domain: "no-internet", code: 22, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.noInternet.value])
    }
    
    struct URL {
        static let contactUs = "https://brasso.jp/contact"
        static let faq = "https://brasso.jp/qa"
        static let termsOfService = "https://brasso.jp/terms"
        static let privacyPolicy = "https://brasso.jp/privacy"
        static let notation = "https://brasso.jp/low"
        static let softwareLiscence = "https://brasso.jp/license"
        static let songLiscence = "https://google.com"
        static let reviewRating = "https://google.com"
        static let opinionRequest = "https://brasso.jp/opinions"
        static let website = "https://brasso.jp"
    }
    
}
