//
//  PlayerListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 22/04/2022.
//

import Foundation
import Alamofire

protocol PlayerListApi {
    
    func fetchPlayerList(of page: Int, keyword: String?, completion: @escaping (Result<(models: [Musician], totalPages: Int), Error>) -> Void)
    
}

extension PlayerListApi {
    
    func fetchPlayerList(of page: Int = 1, keyword: String? = nil, completion: @escaping (Result<(models: [Musician], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "musician", method: .get)
            var parameters = ["page": "\(page)"]
            if let keyword = keyword, !keyword.isEmpty {
                parameters["keyword"] = keyword
            }
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<([Musician], Pagination?), Error>) in
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
