//
//  CartListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 11/05/2022.
//

import Foundation
import Alamofire

protocol CartListApi {
    
    func fetchCartList(of page: Int,
                       completion: @escaping (Result<(models: [CartItem], totalPages: Int), Error>) -> Void)
    
}

extension CartListApi {
    
    func fetchCartList(of page: Int = 1,
                       completion: @escaping (Result<(models: [CartItem], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "cart-item", method: .get, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request(body: ["page": "\(page)"])) { (result: Result<([CartItem], Pagination?), Error>) in
                switch result {
                case .success((let models, let pagination)):
                    let oldRealmModels: [CartItem] = DatabaseHandler.shared.fetch()
                    DatabaseHandler.shared.delete(object: oldRealmModels)
                    DatabaseHandler.shared.writeObjects(with: models)
                    let newModels = models.map {  CartItem(value: $0)}
                    completion(.success((newModels, pagination?.totalPages ?? 1)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
