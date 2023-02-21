//
//  PurchaseApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/05/2022.
//

import Foundation
import Alamofire

protocol CheckoutApi {
    
    func checkout(items: [CartItem],
                  completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension CheckoutApi {
    
    func checkout(items: [CartItem],
                  completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-purchase", method: .post, needsAuthorization: true)
            let parameters: [String: Any] = [
                "items": items.compactMap({$0.dictionary})
            ]
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<(ResponseMessage, Pagination?), Error>) in
                switch result {
                case .success((let model, _)):
                    GlobalConstants.Notification.didBuy.fire(withObject: items)
                    let cartItemsIDs = items.compactMap({$0.id})
                    if !cartItemsIDs.isEmpty {
                        cartItemsIDs.forEach({
                            if let realmModel: CartItem = DatabaseHandler.shared.fetch(primaryKey: $0) {
                                DatabaseHandler.shared.delete(object: [realmModel])
                            }
                        })
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
