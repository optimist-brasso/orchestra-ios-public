//
//  SessionListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/10/2022.
//

import Foundation
import Alamofire

protocol SessionListApi {
    
    func fetchSessionList(of page: Int, keyword: String?, completion: @escaping (Result<(models: [Session], totalPages: Int), Error>) -> Void)
    
}

extension SessionListApi {
    
    func fetchSessionList(of page: Int = 1, keyword: String?, completion: @escaping (Result<(models: [Session], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "session-list", method: .get)
            var parameters: [String: Any] = [
                "page": "\(page)"
            ]
            if let keyword = keyword {
                parameters["keyword"] = keyword
            }
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<([Session], Pagination?), Error>) in
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
