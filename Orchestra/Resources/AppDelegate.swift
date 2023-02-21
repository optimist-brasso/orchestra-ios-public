//
//  AppDelegate.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import LineSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, LoggedInProtocol {
    
    var backgroundCompletionHandler: (() -> ())?
    private lazy var appInfoManager: AppInfoManager = {
        AppInfoManager()
    }()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        ApplicationDelegate.shared.application(application,
                                               didFinishLaunchingWithOptions: launchOptions)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        _ = DatabaseHandler.shared.prepare()
        
        let url = URL(string: "https://www.google.com/")
       
        Task { @MainActor in
            do {
            let urlRequest = try  URLRequest(url: url!, method: .get)
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                    print(data)
                   print(response)
                                                                     }
            catch {
                print(error.localizedDescription)
            }
            
        }
        //        registerNotification(application)        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        let callbackUrl = URL(string: TwitterConstants.CALLBACK_URL)!
        return LoginManager.shared.application(app, open: url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Handle events for background session
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        backgroundCompletionHandler = completionHandler
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            if rootViewController is SessionLayoutViewController ||
                rootViewController is InstrumentPlayerViewController ||
                rootViewController is InstrumentPlayerPopupViewController {
                return .landscape
            }
            if rootViewController is UIAlertController,
               let lastViewController = ((rootViewController.presentingViewController as? TabBarViewController)?.selectedViewController as? UINavigationController)?.viewControllers.last,
               lastViewController is SessionLayoutViewController ||
                lastViewController is InstrumentPlayerViewController ||
                rootViewController is InstrumentPlayerPopupViewController {
                return .landscape
            }
        }
        return .portrait
    }
    
    //MARK: Other functions
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)} else if (rootViewController.isKind(of: UINavigationController.self)) {
                return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
            } else if (rootViewController.presentedViewController != nil) {
                return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
            }
        return rootViewController
    }
}
