//
//  SessionFavouriteApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/10/2022.
//

import Foundation
import Alamofire

enum SessionFavoriteFromType {
    case search
    case playlist
    case favorite
    case none
    case part
    case premium
    case appendix
}

struct SessionFavoriteFrom {
    var session: Session
    var type: SessionFavoriteFromType
}

protocol SessionFavouriteApi {
    
    func favourite(of id: Int, instrumentId: Int, musicianId: Int, from: SessionFavoriteFromType, completion: @escaping (Result<Session, Error>) ->  Void)
    
}

extension SessionFavouriteApi {
    
    func favourite(of id: Int, instrumentId: Int, musicianId: Int, from: SessionFavoriteFromType, completion: @escaping (Result<Session, Error>) ->  Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "favourite-orchestra-musician", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "orchestra_id": id,
                "instrument_id": instrumentId,
                "musician_id": musicianId
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(Session, _), Error>) in
                switch result {
                case .success((let model, _)):
                    GlobalConstants.Notification.didUpdateFavourite.fire(withObject: SessionFavoriteFrom(session: model, type: from))
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                    debugPrint(error.localizedDescription)
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}

