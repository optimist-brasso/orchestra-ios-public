//
//  BaseWireframe.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit
import Combine

enum AppRoutable {
    case pop
    case registerByEmail
    case otp
    case registerPassword
    case updateProfile(String?)
    case login
    case homePage
    case resetPassword(String)
    case splash
}


class BaseWireframe: WireframeInput {
    
    var storyboardName: String  { "" }
    
    func getMainView() -> UIViewController {
        view
    }
    
    var bag = Set<AnyCancellable>()
    var view: UIViewController!
    
    private var finished: (() -> ())?
    
    var childWireframe: BaseWireframe? {
        didSet {
            childWireframe?.finished = removeChild
        }
    }
    
    init() {
        setViewController()
    }
    
    func handleTrigger(trigger: AppRoutable) {
        switch trigger {
        case .pop:
            finished?()
            //        case .login:
            //            openLogin()
        case .splash:
            view.view.window?.rootViewController = SplashWireframe().getMainView()
        case .homePage:
            openTabbar()
        default:
            break
        }
    }
    
    private func removeChild() {
        childWireframe = nil
    }
    
    deinit {
        debugPrint("De-Initialized --> \(String(describing: self))")
    }
    
    func setViewController() {
        
    }
    
    private func openTabbar() {
        view.view.window?.rootViewController = TabBarViewController()
    }
    
}

