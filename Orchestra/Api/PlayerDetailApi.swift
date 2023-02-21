//
//  PlayerDetailApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 25/04/2022.
//

import Foundation
import Alamofire

protocol PlayerDetailApi {
    
    func fetchPlayerDetail(of id: Int, completion: @escaping (Result<Musician, Error>) -> Void)
    
}

extension PlayerDetailApi {
    
    func fetchPlayerDetail(of id: Int, completion: @escaping (Result<Musician, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "musician/\(id)", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(Musician, _), Error>) in
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
