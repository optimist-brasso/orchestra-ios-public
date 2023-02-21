//
//  AddToCartApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/05/2022.
//

import Foundation
import Alamofire

protocol AddToCartApi {
    
    func addToCart(items: [CartItem],
                   completion: @escaping (Result<[CartItem], Error>) -> Void)
    
}

extension AddToCartApi {
    
    func addToCart(items: [CartItem],
                   completion: @escaping (Result<[CartItem], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "cart-item", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "items": items.compactMap({$0.dictionary})
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<([CartItem], Pagination?), Error>) in
                switch result {
                case .success((let models, _)):
                    let oldRealmModels: [CartItem] = DatabaseHandler.shared.fetch()
                    DatabaseHandler.shared.delete(object: oldRealmModels)
                    DatabaseHandler.shared.writeObjects(with: models)
                    GlobalConstants.Notification.didAddToCart.fire()
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
