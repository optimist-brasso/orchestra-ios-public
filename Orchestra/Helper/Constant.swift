//
//  Constant.swift
//  Orchestra
//
//  Created by manjil on 04/04/2022.
//

import UIKit

enum AlertConstant: AlertActionable {
    
    case ok
    case logout
    case cancel
    case login
    
    var title: String {
        switch self {
        case .ok:
            return  LocalizedKey.ok.value
        case .logout:
            return  LocalizedKey.logout.value
        case .cancel:
            return LocalizedKey.cancel.value
        case .login:
            return LocalizedKey.login.value
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .logout:
            return .destructive
        case .cancel:
            return .cancel
        default:
            return .default
        }
    }
    
    var tag: Int {
        return 0
    }
    
}

struct UserConstant: LoggedInProtocol {
    
}

extension Notification {
    
    static let logOut  = Notification.Name.init(rawValue: "LOG_OUT")
    static let update  = Notification.Name.init(rawValue: "UPDATE_PROFILE")
    static let playAudioMiniPlayer = Notification.Name.init(rawValue: "PLAYAUDIO_MINIPLAYER")
    static let nextAudioMiniPlayer = Notification.Name.init(rawValue: "NEXTAUDIO_MINIPLAYER")
    static let fastForwardAudioMiniPlayer = Notification.Name.init(rawValue: "FAST_FORWORD_AUDIO_MINIPLAYER")
    static let audioMiniPlayerURL = Notification.Name.init(rawValue: "URLAUDIO_MINIPLAYER")
    static let passHallSoundDetailViewModel = Notification.Name.init(rawValue: "HALLSOUNDDETAILVIEWMODEL")
    static let dismissPopUpAudioMiniPlayer = Notification.Name.init(rawValue: "DISMISSPOPUP_MINIPLAYER")
    static let audioPlayerPlayingStatus = Notification.Name.init(rawValue: "AUDIOPLAYER_STATUS")
    static let logoutUser =  Notification.Name(rawValue: "LOGOUT_USER")
    static let userLoggedOut = Notification.Name(rawValue: "LOGGEDOUT_USER")
    static let logoutSuccess = Notification.Name(rawValue: "LOUOUT_USER_SUCCESS")
    static let showLogoutView = Notification.Name(rawValue: "SHOW_LOGOUT_VIEW")
}
