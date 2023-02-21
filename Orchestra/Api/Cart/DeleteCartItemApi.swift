//
//  DeleteCartItemApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/05/2022.
//

import Foundation
import Alamofire

protocol DeleteCartItemApi {
    
    func deleteCartItem(of id: Int,
                        completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension DeleteCartItemApi {
    
    func deleteCartItem(of id: Int,
                        completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "delete-cart-item/\(id)", method: .delete, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(ResponseMessage, Pagination?), Error>) in
                switch result {
                case .success((let model, _)):
                    if let cartItem: CartItem = DatabaseHandler.shared.fetch(primaryKey: id) {
                        DatabaseHandler.shared.delete(object: [cartItem])
                        GlobalConstants.Notification.didAddToCart.fire()
                    }
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
