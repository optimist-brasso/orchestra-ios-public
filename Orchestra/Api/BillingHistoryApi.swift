//
//  BillingHistoryApi.swift
//  Orchestra
//
//  Created by rohit lama on 17/05/2022.
//

import Foundation
import Alamofire

protocol BillingHistoryApi {
    
    func fetchBillingHistory(of page: Int, completion: @escaping (Result<(models: [BillingHistory], totalPages: Int), Error>) -> Void)
    func fetchPointHistory(of page: Int, completion: @escaping (Result<(models: [PointHistory], totalPages: Int), Error>) -> Void)
    
}

extension BillingHistoryApi {
    
    func fetchBillingHistory(of page: Int = 1, completion: @escaping (Result<(models: [BillingHistory], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "billing-history", method: .get, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<([BillingHistory], Pagination?), Error>) in
                switch result {
                case .success((let models, let pagination)):
                    completion(.success((models, pagination?.totalPages ?? 1)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
    func fetchPointHistory(of page: Int = 1, completion: @escaping (Result<(models: [PointHistory], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "bundle-purchase", method: .get, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request(body: ["page": "\(page)"])) { (result: Result<([PointHistory], Pagination?), Error>) in
                switch result {
                case .success((let models, let pagination)):
                    completion(.success((models, pagination?.totalPages ?? 1)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
