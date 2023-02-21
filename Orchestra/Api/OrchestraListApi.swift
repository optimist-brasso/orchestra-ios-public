//
//  OrchestraListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import Foundation
import Alamofire

protocol OrchestraListApi {
    
    func fetchOrchestraList(of page: Int, completion: @escaping (Result<(models: [Orchestra], totalPages: Int), Error>) -> Void)
    
}

extension OrchestraListApi {
    
    func fetchOrchestraList(of page: Int = 1, completion: @escaping (Result<(models: [Orchestra], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra", method: .get)
            URLSession.shared.dataTask(request: endPoint.request(body: ["page": "\(page)"])) { (result: Result<([Orchestra], Pagination?), Error>) in
                switch result {
                case .success((let models, let pagination)):
    //                let oldRealmModels: [Orchestra] = DatabaseHandler.shared.fetch()
    //                DatabaseHandler.shared.delete(object: oldRealmModels)
    //                DatabaseHandler.shared.writeObjects(with: models)
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
