//
//  OrchestraPlayerListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/07/2022.
//

import Foundation
import Alamofire

protocol OrchestraPlayerListApi {
    
    func fetchPlayerList(of page: Int, id: Int, completion: @escaping (Result<(models: [Musician], totalPages: Int), Error>) -> Void)
    
}

extension OrchestraPlayerListApi {
    
    func fetchPlayerList(of page: Int = 1, id: Int, completion: @escaping (Result<(models: [Musician], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-player/\(id)", method: .get)
            let parameters = ["page": "\(page)"]
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
