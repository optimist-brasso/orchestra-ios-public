//
//  ForgotPasswordApi.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation

public protocol ForgotPasswordApi {
    
    func forgotPassword(email: String,
                        completion: @escaping (Result<String, Error>) -> ())
    
}

public extension ForgotPasswordApi {
    
    func forgotPassword(email: String,
                        completion: @escaping (Result<String, Error>) -> ()) {
        let parameters = [
            "email": email
        ]
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/forgot-password", method: .post)
        let request = endPoint.request(body: parameters)
        urlSession.dataTask(request: request) { (result: Result<(ResponseMessage, Pagination?), Error>) in
            switch result {
            case .success((let response, _)):
                completion(.success(response.detail ?? "Please check for code in email to reset your password."))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
