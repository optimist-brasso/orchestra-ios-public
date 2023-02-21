//
//  UnregisterFCMApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/08/2022.
//

import Foundation
import FirebaseMessaging
import Alamofire

protocol UnregisterFCMApi {
    
    func unregisterFCM(completion: @escaping (Result<ResponseMessage, Error>) ->  Void)
    
}

extension UnregisterFCMApi {
    
    func unregisterFCM(completion: @escaping (Result<ResponseMessage, Error>) ->  Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "unregister-fcm", method: .delete)
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
