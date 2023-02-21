//
//  ChangePasswordService.swift
//  Orchestra
//
//  Created by manjil on 15/04/2022.
//

import Foundation

import Combine
import Alamofire

class ChangePasswordService: ChangePassowrdApi {
    
    let response = PassthroughSubject<(String, Bool), Never>()
    
    func changePassword(new: String, old: String) {
        if NetworkReachabilityManager()?.isReachable == true {
            changePassword(oldPassword: old, newPassword: new, confirmPassword: new) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let message):
                    self.response.send((message, true))
                case .failure(let error):
                    self.response.send((error.localizedDescription, false))
                }
            }
        } else {
            response.send((GlobalConstants.Error.noInternet.localizedDescription, false))
        }
    }
    
}
