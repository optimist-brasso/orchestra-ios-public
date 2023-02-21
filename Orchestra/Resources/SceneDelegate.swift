//
//  SceneDelegate.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//

import UIKit

import IQKeyboardManagerSwift
import LineSDK
import FBSDKCoreKit
import SwiftyStoreKit
import FirebaseCore
import FirebaseMessaging
import RealmSwift

let deploymentMode: DeploymentMode = .uat

//let deploymentMode: DeploymentMode =  {
//#if DEBUG
//    return .qa
//    #elseif RELEASE
//    return .qa
//    #elseif UAT
//    return .qa
//    #else
//    return .qa
//#endif
//}()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var wireframe: BaseWireframe!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        if window == nil { window = UIWindow(windowScene: windowScene) }
        // need to change url string
        window?.makeKeyAndVisible()
        setupSocialLogin()
        IQKeyboardManager.shared.enable = true
        migrateRealm()
        setupDeployment()
        setupAppearance()
        setupInitialValue()
        IAP.shared.completeTransactions()
        configureFirebase()
        
        requestNotificationAuthorization()
        
        let baseNavigation = BaseNavigationController()
        window?.rootViewController = baseNavigation
        wireframe = AppWireframe(route: baseNavigation, scene: window)
    }
    
    func scene ( _ scene : UIScene , openURLContexts URLContexts : Set < UIOpenURLContext >) {
        guard let url = URLContexts.first?.url else { return }
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation] )
        
        let callbackUrl = URL(string: TwitterConstants.CALLBACK_URL)!
        _ = LoginManager.shared.application(.shared, open: URLContexts.first?.url)
    }
    
    private func setupDeployment() {
        var conf: Configuration {
            switch deploymentMode {
            case .uat:
                return Configuration(clientId: "ENTER_YOUR_CLIENT_ID_HERE",
                                     clientSecret: "ENTER_YOUR_CLIENT_SECRET_HERE",
                                     baseURL: "ENTER_YOUR_BASE_URL_HERE")
            case .live:
                return Configuration(clientId: "ENTER_YOUR_CLIENT_ID_HERE",
                                     clientSecret: "ENTER_YOUR_CLIENT_SECRET_HERE",
                                     baseURL: "ENTER_YOUR_BASE_URL_HERE")
            default:
                return Configuration(clientId: "ENTER_YOUR_CLIENT_ID_HERE",
                                     clientSecret: "ENTER_YOUR_CLIENT_SECRET_HERE",
                                     baseURL: "ENTER_YOUR_BASE_URL_HERE")
            }
        }
        Configuration.conf = conf
    }
    
    private func setupAppearance() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = .zero
        }
        setupNavBar()
        setupTabBar()
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBar.appearance()
        let navBarColor = UIColor(hexString: "#333333")
        appearance.backgroundColor = navBarColor
        appearance.barTintColor = navBarColor
        appearance.tintColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(type: .notoSansJP(.bold), size: .size22),
                                          NSAttributedString.Key.foregroundColor: UIColor.white]
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = navBarColor
            navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appFont(type: .notoSansJP(.bold), size: .size22),
                                                           NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.standardAppearance = navigationBarAppearance
            appearance.compactAppearance = navigationBarAppearance
            appearance.scrollEdgeAppearance = navigationBarAppearance
        }
    }
    
    private func setupTabBar() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .black
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        let tintColor = UIColor.appGreen
        let tabBarItemAppearance = UITabBarItem.appearance()
        let tabBarAppearance = UITabBar.appearance()
        let font: UIFont = .appFont(type: .notoSansJP(.regular), size: .size10)
        tabBarItemAppearance.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: font],
            for: .normal)
        tabBarItemAppearance.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: tintColor,
             NSAttributedString.Key.font: font],
            for: .selected)
        tabBarAppearance.backgroundColor = .black
        tabBarAppearance.tintColor = tintColor
        tabBarAppearance.isTranslucent = true
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.post(Notification(name: UIApplication.willEnterForegroundNotification))
    }
    
    private func setupTransactionObaserver() {
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed,
                        .purchasing,
                        .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func setupInitialValue() {
        if Cacher().value(type: RecordingSettings.self, forKey: .recordingSettings) == nil {
            let _ = RecordingSettings()
        }
        if Cacher().value(type: StreamingDownloadSetting.self, forKey: .streamingDownloadSettings) == nil {
            let _ = StreamingDownloadSetting()
        }
    }
    
    private func configureFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    private func requestNotificationAuthorization() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    private func migrateRealm() {
        let newRealmConfiguration = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = newRealmConfiguration
    }
    
    private func setupSocialLogin() {
        var link: URL?
        switch deploymentMode {
        case .uat:
            link = URL(string: "ENTER_YOUR_LINE_UNIVERSAL_LINK_HERE")
        case .live:
            link = URL(string: "ENTER_YOUR_LINE_UNIVERSAL_LINK_HERE")
        default:
            break
        }
        LoginManager.shared.setup(channelID: "ENTER_YOUR_LINE_CHANNEL_ID_HERE", universalLinkURL: link)
    }
    
}

//MARK: MessagingDelegate
extension SceneDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        registerFCM { _ in }
    }
    
}

//MARK: RegisterFCMApi
extension SceneDelegate: RegisterFCMApi {}

@available(iOS 10, *)
//MARK: UNUserNotificationCenterDelegate
extension SceneDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationHandler.shared.receivedNotification(userInfo)
        completionHandler()
    }
    
}

//Adding here for now.
struct TwitterConstants {
    
    static let CALLBACK_URL = "ENTER_YOUR_TWITTER_CALLBACK_URL_HERE"
    
}
