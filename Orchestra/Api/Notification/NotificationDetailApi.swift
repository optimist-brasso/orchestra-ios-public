//
//  NotificationDetailApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 08/06/2022.
//

import Foundation
import RealmSwift
import Alamofire

protocol NotificationDetailApi {
    
    func fetchNotificationDetail(of id: Int, completion: @escaping (Result<PushNotification, Error>) -> Void)
    
}

extension  NotificationDetailApi {
    
    func fetchNotificationDetail(of id: Int, completion: @escaping (Result<PushNotification, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "notification/\(id)", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(PushNotification, Pagination?), Error>) in
                switch result {
                case .success((let response, _)):
                    let notifications: [PushNotification] = DatabaseHandler.shared.fetch(filter: "isSeen == false")
                    UIApplication.shared.applicationIconBadgeNumber = notifications.count
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
