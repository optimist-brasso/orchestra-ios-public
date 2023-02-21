//
//  NotificationApi.swift
//  Orchestra
//
//  Created by manjil on 27/04/2022.
//

import Foundation
import RealmSwift
import Alamofire

protocol NotificationApi {
    
    func getNotificationList(completion: @escaping (Result<[PushNotification], Error>) -> Void)
    
}

extension  NotificationApi {
    
    func getNotificationList(completion: @escaping (Result<[PushNotification], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "notification", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<([PushNotification], Pagination?), Error>) in
                switch result {
                case .success((let response, _)):
                    let oldRealmModels: [PushNotification] = DatabaseHandler.shared.fetch()
                    DatabaseHandler.shared.update {
                        response.forEach({ notification in
                            if let oldNotification: PushNotification = DatabaseHandler.shared.fetch(primaryKey: notification.id), oldNotification.isSeen {
                                notification.isSeen = oldNotification.isSeen
                            }
                        })
                    }
                    DatabaseHandler.shared.delete(object: oldRealmModels)
                    DatabaseHandler.shared.writeObjects(with: response)
                    GlobalConstants.Notification.didReadNotification.fire()
                    let newResponse = response.map { PushNotification(value: $0) }
                    completion(.success(newResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
