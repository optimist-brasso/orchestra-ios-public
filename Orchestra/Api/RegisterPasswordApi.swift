//
//  RegisterPasswordApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/05/2022.
//

import Foundation
import Alamofire

protocol RegisterPasswordApi {
    
    func register(email: String, password: String, completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension RegisterPasswordApi {
    
    func register(email: String, password: String, completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "auth/set-password", method: .post, needsAuthorization: false)
            let parameters: [String: Any] = [
                "email": email,
                "password": password
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(ResponseMessage, _), Error>) in
                switch result {
                case .success((let response, _)):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
