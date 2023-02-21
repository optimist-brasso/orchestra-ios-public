//
//  MyPageContentInteractor.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 05/04/2022.
//
//

import Foundation


class MyPageContentInteractor {
    
	// MARK: Properties
    weak var output: MyPageContentInteractorOutput?
    private let service: MyPageContentServiceType
    
    // MARK: Initialization
    init(service: MyPageContentServiceType) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(logoutUser), name: Notification.logoutUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutSuccess), name: Notification.logoutSuccess, object: nil)
    }

    // MARK: Converting entities
    @objc private func logoutUser() {
        service.unregisterFCM { [weak self] result in
            switch result {
            case .success(_):
                self?.service.clearDatabase()
                Cacher().delete(forKey: .email)
                KeyChainManager.standard.clear()
                NotificationCenter.default.post(name: Notification.userLoggedOut, object: nil)
            case .failure(let error):
                self?.output?.obtained(error)
            }
        }
    }
    
    @objc private func logoutSuccess() {
        output?.obtainedLogoutSuccess()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: MyPageContent interactor input interface
extension MyPageContentInteractor: MyPageContentInteractorInput {
    
    func getData() {
        let isLoggedIn = service.isLoggedIn
        output?.obtainedLoggedIn(status: service.isLoggedIn)
        if isLoggedIn {
            output?.obtainedSocialLogin(status: service.isSocialLogin)
        }
    }
    
    func logout() {
        NotificationCenter.default.post(name: Notification.showLogoutView, object: nil)
    }
    
}
