//
//  RegistersPresenter.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import Combine



class RegistersPresenter: BasePresenter, SocialLoginApi, CartListApi {

    let response = PassthroughSubject<(String, Bool), Never>()
    
    func request(token: String,  userIdentifier: String? = nil, type: Provider) {
        socialLogin(accessToken: token, userIdentifier: userIdentifier, name: nil, type: type) { [weak self] response  in
            guard let self = self else { return }
            switch response {
                case .success(_):
                self.response.send(("", true))
//                self.fetchCartList(of: 1) { [weak self] result in
//                    switch result {
//                    case .success((_, _)):
//                        self?.response.send(("", true))
////                        self?.trigger.send(.homePage)
//                    case .failure(let error):
//                        self?.response.send((error.localizedDescription, false))
//                    }
//                }
                  //  self.response.send(("", true))
              //  NotificationCenter.default.post(name: Notification.homePage, object: nil)
            case .failure(let error):
                self.response.send((error.localizedDescription, false))
            }
        }
    }
    
}
