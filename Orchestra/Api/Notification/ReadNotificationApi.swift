//
//  ReadNotificationApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/06/2022.
//

import Foundation
import Alamofire

protocol ReadNotificationApi {
    
    func readNotification(of ids: [Int], completion: @escaping (Result<ResponseMessage, Error>) ->  Void)
    
}

extension ReadNotificationApi {
    
    func readNotification(of ids: [Int], completion: @escaping (Result<ResponseMessage, Error>) ->  Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "notification/bulk-read", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "ids": ids
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
