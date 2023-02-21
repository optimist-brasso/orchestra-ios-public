//
//  SplashInteractor.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 12/04/2022.
//
//

import Foundation
import Alamofire
import UIKit.UIApplication
import Network

class SplashInteractor {
    
    // MARK: Properties
    weak var output: SplashInteractorOutput?
    private let service: SplashServiceType
    private let dispatchGroup = DispatchGroup()
    private var profileStatus = false
    private var email: String?
    var redirectionRequired = false

    // MARK: Initialization
    var appInfo = AppInfoManager()
    
    init(service: SplashServiceType) {
        self.service = service
    }
    
}

// MARK: Splash interactor input interface
extension SplashInteractor: SplashInteractorInput {
    
    func getData() {
        requestAppInfo { [weak self] in
            self?.redirectApp()
        }
        
//        if NetworkReachabilityManager()?.isReachable == true {
//            requestAppInfo { [weak self] in
//                self?.redirectApp()
//            }
//        } else {
//            output?.obtained(NSError(domain: "no-internet", code: 22, userInfo: [NSLocalizedDescriptionKey: "インターネット接続がありません。接続を確認してください"]))
//        }
    }
    
    private func requestAppInfo(completion: @escaping (() -> Void)) {
        InternalReachability.default.checkReachability { [weak self] isReachable in
            if isReachable {
                self?.appInfo.request(completionHandeler: { [weak self] error in
                    if error != nil  {
                        self?.output?.obtained(EK_GlobalConstants.Error.oops)
                    }
                    completion()
                })
            } else {
                self?.noInternetOutput()
                completion()
            }
        }
    }
    
    private func redirectApp() {
        if redirectionRequired && profileStatus {
            output?.obtainedSuccess()
            return
        }
        
        InternalReachability.default.checkReachability { [weak self] isReachable in
            guard let self = self else { return }
            if isReachable {
                self.fetchNotification()
                if self.service.isLoggedIn {
                    self.getCart()
                    self.getProfile()
                    self.syncNotificationRead()
                }
                self.dispatchGroup.notify(queue: .main) { [weak self] in
                    guard let self = self else { return }
                    if !(self.service.isLoggedIn) ||
                        self.profileStatus ||
                        !(Cacher().get(Bool.self, forKey: .isAppPreviouslyOpen) ?? false) {
                        self.output?.obtainedSuccess()
                    } else if self.service.isLoggedIn && !(self.profileStatus) {
                        self.output?.obtainedProfileUpdateNeed(for: self.email)
                    } else {
                        self.output?.obtained(EK_GlobalConstants.Error.oops)
                    }
                }
            } else {
                self.noInternetOutput()
            }
        }
    }
    
    private func getCart() {
        dispatchGroup.enter()
        service.fetchCartList { [weak self] result in
            switch result {
            case .success(_):
                self?.dispatchGroup.leave()
            case .failure(_):
                self?.output?.obtained(EK_GlobalConstants.Error.oops)
                self?.dispatchGroup.leave()
            }
        }
    }
    
    private func getProfile() {
        dispatchGroup.enter()
        service.fetchProfile { [weak self] result in
            defer {
                self?.dispatchGroup.leave()
            }
            switch result {
            case .success(let model):
                self?.email = model.email
                self?.profileStatus = model.profileStatus ?? false
            case .failure(_):
                self?.output?.obtained(EK_GlobalConstants.Error.oops)
                
            }
        }
    }
    
    private func syncNotificationRead() {
        dispatchGroup.enter()
        guard let readNotificationIds = service.readNotificationIds,
              !readNotificationIds.isEmpty else {
            dispatchGroup.leave()
            return
        }
        service.readNotification(of: readNotificationIds) { [weak self] _ in
            self?.dispatchGroup.leave()
            self?.fetchNotification()
        }
    }
    
    private func fetchNotification() {
        dispatchGroup.enter()
        service.getNotificationList { [weak self] _ in
            UIApplication.shared.applicationIconBadgeNumber = self?.service.unreadNotificationCount ?? .zero
            self?.dispatchGroup.leave()
        }
    }
   
    private func noInternetOutput() {
      output?.obtained(NSError(domain: "no-internet", code: 22, userInfo: [NSLocalizedDescriptionKey: "インターネット接続がありません。接続を確認してください"]))
   }
}
