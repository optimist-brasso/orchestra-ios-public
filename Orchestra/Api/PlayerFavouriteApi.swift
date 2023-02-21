//
//  PlayerFavouriteApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 27/04/2022.
//

import Foundation
import Alamofire

protocol PlayerFavouriteApi {
    
    func favouritePlayer(of id: Int, completion: @escaping (Result<Favourite, Error>) ->  Void)
    
}

extension PlayerFavouriteApi {
    
    func favouritePlayer(of id: Int, completion: @escaping (Result<Favourite, Error>) ->  Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "favourite-musician", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "musician_id": id,
                "type": OrchestraType.player.rawValue
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(Favourite, _), Error>) in
                switch result {
                case .success((let response, _)):
                    let isFavourite = response.musician?.isFavourite ?? false
                    response.musician = Musician()
                    response.musician?.id = id
                    response.musician?.isFavourite = isFavourite
                    response.type = OrchestraType.player.rawValue
                    GlobalConstants.Notification.didUpdateFavourite.fire(withObject: response)
                    NotificationCenter.default.post(name: GlobalConstants.Notification.didUpdateFavouriteItem.notificationName, object: nil)
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
