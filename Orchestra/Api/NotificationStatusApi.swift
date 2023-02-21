//
//  NotificationStatusApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/01/2023.
//

import Foundation
import Alamofire

protocol NotificationStatusApi {
    
    func toggle(completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension NotificationStatusApi {
    
    func toggle(completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "notification/toggle-notification-status", method: .post, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(ResponseMessage, _), Error>) in
                switch result {
                case .success((let model, _)):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
