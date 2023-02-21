//
//  MyPageInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//  Copyright © 2022 Orchestra. All rights reserved.
//

import Foundation
import Alamofire

class MyPageInteractor {
    
	// MARK: Properties
    weak var output: MyPageInteractorOutput?
    private let service: MyPageServiceType
    var index: Int?
    
    // MARK: Initialization
    init(service: MyPageServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToCart), name: GlobalConstants.Notification.didAddToCart.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReadNotification), name: GlobalConstants.Notification.didReadNotification.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapLogout), name: Notification.showLogoutView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUserLogout), name: Notification.userLoggedOut, object: nil)
    }
    
    //MARK: Other functions
    @objc private func didAddToCart() {
        output?.obtained(cartCount: service.cartCount)
    }
    
    @objc private func didReadNotification() {
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    @objc private func didTapLogout() {
        output?.openLogoutView()
    }
    
    @objc private func didUserLogout() {
        output?.obtainedSuccess()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: MyPage interactor input interface
extension MyPageInteractor: MyPageInteractorInput {
    
    func getData() {
        output?.obtained(cartCount: service.cartCount)
        output?.obtained(notificationCount: service.notificationCount)
    }
    
    func checkLoginStatus() {
        output?.obtainedLoginStatus(service.isLoggedIn)
    }
    
    func logout() {
        if NetworkReachabilityManager()?.isReachable == true {
            NotificationCenter.default.post(name: Notification.logoutUser, object: nil)
        } else {
            output?.obtained(GlobalConstants.Error.noInternet)
        }
    }
    
}
