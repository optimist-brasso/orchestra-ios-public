//
//  PaymentApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 21/07/2022.
//

import Foundation
import Alamofire

protocol PaymentApi {
    
    func verify(receipt: String, excludeOldTransactions: Bool, completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension PaymentApi {
    
    func verify(receipt: String, excludeOldTransactions: Bool = false, completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "apple-pay", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "apple_token": receipt,
                "exclude_old_transactions": excludeOldTransactions
            ]
            print(parameters)
            let sessionConfig = URLSessionConfiguration.default
    //        sessionConfig.timeoutIntervalForRequest = 180
    //        sessionConfig.timeoutIntervalForResource = 180
            let urlSession = URLSession(configuration: sessionConfig)
            urlSession.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(ResponseMessage, _), Error>) in
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
