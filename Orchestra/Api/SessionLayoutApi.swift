//
//  SessionLayoutApi.swift
//  Orchestra
//
//  Created by PRAKASH CHANDRA AWAL on 5/10/22.
//

import Foundation
import Alamofire

protocol SessionLayoutApi {
    
    func fetchLayoutSession(of id: Int, completion: @escaping (Result<Session, Error>) -> Void)
    
}

extension SessionLayoutApi {
    
    func fetchLayoutSession(of id: Int, completion: @escaping(Result<Session, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-layout/\(id)", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(Session, _), Error>) in
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
