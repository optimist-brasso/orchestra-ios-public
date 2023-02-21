//
//  PointListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 26/09/2022.
//

import Foundation
import Alamofire

protocol PointListApi {
    
    func fetchPoints(completion: @escaping ((Result<PointHistory, Error>) -> Void))
    
}

extension PointListApi {
    
    func fetchPoints(completion: @escaping ((Result<PointHistory, Error>) -> Void)) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "bundle-list", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(PointHistory, Pagination?), Error>) in
                switch result {
                case .success((let models, _)):
                    completion(.success(models))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
    
    func fetchFreePoints(completion: @escaping ((Result<[Point], Error>) -> Void)) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "free-point-list", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<([Point], Pagination?), Error>) in
                switch result {
                case .success((let models, _)):
                    completion(.success(models))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
