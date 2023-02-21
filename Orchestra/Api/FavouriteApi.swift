//
//  FavouriteApi.swift
//  Orchestra
//
//  Created by manjil on 26/04/2022.
//

import Foundation
import Alamofire

protocol FavouriteApi {
    
}

extension FavouriteApi {
    
    func getFavouriteList(completion: @escaping (Result<[Favourite], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "my-favourite-orchestra", method: .get, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<([Favourite], _), Error>) in
                switch result {
                case .success((let response, _)):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
//    func makeFavouriteAndUn(param: [String: Any],  completion: @escaping (Result<ResponseMessage, Error>) ->  Void)   {
//        let endPoint = EK_EndPoint(path: "orchestra-favourite", method: .post, needsAuthorization: true)
//        URLSession.shared.dataTask(request: endPoint.request(body: param)) { (result: Result<(ResponseMessage, _), Error>) in
//            switch result {
//            case .success((let response, _)):
//                completion(.success(response))
//                print(response.detail ?? "ERROR_makeFavouriteAndUn func")
//            case .failure(let error):
//                completion(.failure(error))
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func getFavouritePlayer(param: [String: Any], completion: @escaping (Result<([FavouritePlayer], Pagination?), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "my-favourite-musician", method: .get, needsAuthorization: true)  //
            URLSession.shared.dataTask(request: endPoint.request(body: param)) { (result: Result<([FavouritePlayer], Pagination?), Error>) in
                switch result {
                case .success((let response, let page)):
                    completion(.success((response, page)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
//    func  makeFavouriteAndUnPlayer(param: [String: Any],  completion: @escaping (Result<ResponseMessage, Error>) ->  Void)   {
//        let endPoint = EK_EndPoint(path: "favourite-musician", method: .post, needsAuthorization: true) //
//        URLSession.shared.dataTask(request: endPoint.request(body: param)) { (result: Result<(ResponseMessage, _), Error>) in
//            switch result {
//            case .success((let response, _)):
//                completion(.success(response))
//                print(response.detail ?? "ERROR_makeFavouriteAndUnPlayer func")
//            case .failure(let error):
//                completion(.failure(error))
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func search(for keyword: String, completion: @escaping (Result<[Favourite], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "my-favourite-orchestra", method: .get)
            URLSession.shared.dataTask(request: endPoint.request(body: ["keyword": keyword])) { (result: Result<([Favourite], Pagination?), Error>) in
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
    
    func searchPlayer(for keyword: String, completion: @escaping (Result<[FavouritePlayer], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "my-favourite-musician", method: .get)
            URLSession.shared.dataTask(request: endPoint.request(body: ["keyword": keyword])) { (result: Result<([FavouritePlayer], Pagination?), Error>) in
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

