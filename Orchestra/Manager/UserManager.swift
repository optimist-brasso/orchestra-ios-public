//
//  UserManager.swift
//  Orchestra
//
//  Created by manjil on 01/04/2022.
//

import Foundation
import Combine

class UserManager {
    
    var bag = Set<AnyCancellable>()
    let networking = Networking()
    
   // let networkingResult = PassthroughSubject<NetworkingResult<SendToken>, Never>()
    
    public func request<O: Decodable>(type:O.Type, router: Routable) -> AnyPublisher<NetworkingResult<DataParser<O>>, Never> {
        networking.request(type: O.self, router: router).map { [weak self] response -> NetworkingResult<DataParser<O>> in
           self?.inferredResponse(response: response, router: router)
            return response
        }.eraseToAnyPublisher()
    }
    
    public func requestUpload<O: Decodable>(type:O.Type, router: Routable) -> AnyPublisher<NetworkingResult<DataParser<O>>, Never> {
        networking.upload(type: O.self, router: router).map { [weak self] response -> NetworkingResult<DataParser<O>> in
            self?.inferredResponse(response: response, router: router)
            return response
        }.eraseToAnyPublisher()
    }
    
    private func inferredResponse<O: Decodable>(response: NetworkingResult<DataParser<O>>, router: Routable){
        /// we intercept login router to save the user inside cache
        switch router {
        case AuthRouter.sendActivationToken:
            if response.success {
                if let email = response.object?.data as? SendToken  {
                    save(email: email.email)
                }
            }
        default:
            break
        }
    }
    
    func save(email: String) {
        Cacher().setValue(email, key: UserDefaultKey.email)
    }
    
    /// Deinitializer
    deinit {
        print("De-Initialized \(String(describing: self))")
    }
    
}



