//
//  RegisterFCMApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 17/08/2022.
//

import Foundation
import FirebaseMessaging

protocol RegisterFCMApi {
    
    func registerFCM(completion: @escaping (Result<ResponseMessage, Error>) ->  Void)
    
}

extension RegisterFCMApi {
    
    func registerFCM(completion: @escaping (Result<ResponseMessage, Error>) ->  Void) {
        let endPoint = EK_EndPoint(path: "register-fcm", method: .post)
        guard let fcmToken = Messaging.messaging().fcmToken else {
            completion(.failure(NSError(domain: "fcm-error", code: 22, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])))
            return
        }
        let parameters: [String: Any] = [
            "fcm_token": fcmToken
        ]
        URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(ResponseMessage, _), Error>) in
            switch result {
            case .success((let response, _)):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
