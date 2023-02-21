//
//  PurchaseListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/05/2022.
//

import Foundation
import Alamofire

protocol PurchaseListApi {
    
    func fetchPurchaseList(completion: @escaping (Result<Purchased, Error>) -> Void)
    
}

extension PurchaseListApi {
    
    func fetchPurchaseList(completion: @escaping (Result<Purchased, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-purchase", method: .get, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(Purchased, Pagination?), Error>) in
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
