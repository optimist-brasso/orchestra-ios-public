//
//  FCMRegisterApi.swift
//  
//
//  Created by Mukesh Shakya on 18/02/2022.
//

import Foundation

protocol FCMRegisterApi {
    
//    func register(fcmToken: String, userId: Int?, completion: @escaping (Result<String, Error>))
    
}

extension FCMRegisterApi {
    
//    func register(fcmToken: String, userId: Int? = nil, completion: @escaping (Result<String, Error>)) {
//        var parameters: [String: Any] = [
//            "fcm_token": fcmToken
//        ]
//        if let userId = userId {
//             parameters["user_id"] = userId
//        }
//        let urlSession = URLSession.shared
//        let endPoint = EK_EndPoint(path: "notification-user-register", method: "POST")
//        let request = endPoint.request(body: parameters)
//        urlSession.dataTask(request: request) { (result: Result<(ResponseMessage, Pagination?), Error>) in
//            switch result {
//            case .success((let response, _)):
//                completion(.success(response.detail ?? ""))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
}
