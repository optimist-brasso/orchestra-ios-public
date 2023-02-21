//
//  HomeApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 15/04/2022.
//

import Foundation
import Alamofire

protocol HomeApi {
    
    func fetchHome(completion: @escaping (Result<(model: Home, totalPages: Int), Error>) -> Void)
    
}

extension HomeApi {
    
    func fetchHome(completion: @escaping (Result<(model: Home, totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "home", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(Home, Pagination?), Error>) in
                switch result {
                case .success((let model, let pagination)):
                    completion(.success((model, pagination?.totalPages ?? 1)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
