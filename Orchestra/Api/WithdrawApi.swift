//
//  WithdrawApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 13/07/2022.
//

import Foundation
import Alamofire

protocol WithdrawApi {
    
    func withdraw(completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension WithdrawApi {
    
    func withdraw(completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "withdrawal", method: .post, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(ResponseMessage, _), Error>) in
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
