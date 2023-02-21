//
//  OrchestraFavouriteApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 27/04/2022.
//

import Foundation
import Alamofire

protocol OrchestraFavouriteApi {
    
    func favouriteOrchestra(of id: Int, for type: OrchestraType, completion: @escaping (Result<Favourite, Error>) -> Void)
    func favouriteOrchestra(_ model: Orchestra, for type: OrchestraType, completion: @escaping (Result<Favourite, Error>) -> Void)
    
}

extension OrchestraFavouriteApi {
    
    func favouriteOrchestra(of id: Int, for type: OrchestraType = .conductor, completion: @escaping (Result<Favourite, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-favourite", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "orchestra_id": id,
                "type": type.rawValue
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(Favourite, _), Error>) in
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
    
    func favouriteOrchestra(_ model: Orchestra, for type: OrchestraType = .conductor, completion: @escaping (Result<Favourite, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-favourite", method: .post, needsAuthorization: true)
            guard let id = model.id else { return }
            let parameters: [String: Any] = [
                "orchestra_id": id,
                "type": type.rawValue
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(Favourite, _), Error>) in
                switch result {
                case .success((let response, _)):
                    let isFavourite = response.orchestra?.isFavourite ?? false
                    response.orchestra = Orchestra()
                    response.orchestra?.id = model.id
                    response.orchestra?.title = model.title
                    response.orchestra?.titleJapanese = model.titleJapanese
                    response.orchestra?.type = type.rawValue
                    response.orchestra?.tags = model.tags
                    response.orchestra?.image = model.image
                    response.orchestra?.isFavourite = isFavourite
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
