//
//  SearchApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 6/7/22.
//

import Foundation
import Alamofire

protocol SearchApi {
    
    func search(for keyword: String, completion: @escaping (Result<[Orchestra], Error>) -> Void)
    
}

extension SearchApi {
    
    func search(for keyword: String, completion: @escaping (Result<[Orchestra], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-search", method: .get)
            URLSession.shared.dataTask(request: endPoint.request(body: ["keyword": keyword])) { (result: Result<([Orchestra], Pagination?), Error>) in
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
