//
//  LogoutApi.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation

public protocol LogoutApi {
    
    func logout(compeltion: @escaping (Result<Void, Error>) -> ()) 
    
}

public extension LogoutApi {
    
    func logout(compeltion: @escaping (Result<Void, Error>) -> ()) {
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "logout", method: .post, needsAuthorization: true)
        let request = endPoint.request()
        urlSession.dataTask(request: request) { (result: Result<(ResponseMessage, Pagination?), Error>) in
            switch result {
            case .success((_, _)):
                compeltion(.success(()))
            case .failure(let error):
                compeltion(.failure(error))
            }
        }
    }
    
}
