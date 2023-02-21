//
//  SignupService.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//

import Foundation


class SignupService: SignupServiceType {
    
    func socialApiRequest(token: String,
                          userId: String,
                          username: String,
                          type: Provider,
                          completion: @escaping (Result<String, Error>) -> Void) {
        socialLogin(accessToken: token,
                    userIdentifier: userId,
                    name: username,
                    type: type) { result in
            switch result {
            case .success(let data):
                print(data, "------>")
                completion(.success(""))
            case .failure(let error):
                print(error, "------>")
                completion(.failure(error))
            }
        }
    }
    
}
