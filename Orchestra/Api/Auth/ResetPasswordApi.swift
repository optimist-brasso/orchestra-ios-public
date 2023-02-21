//
//  ResetPasswordApi.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation

public protocol ResetPasswordApi {
    
    func resetPassword(email: String,
                       token: String,
                       password: String,
                       confirmPassword: String,
                       completion: @escaping (Result<String, Error>) -> ())
    
}

public extension ResetPasswordApi {
    
    func resetPassword(email: String,
                       token: String,
                       password: String,
                       confirmPassword: String,
                       completion: @escaping (Result<String, Error>) -> ()) {
        if password != confirmPassword {
            completion(.failure(EK_GlobalConstants.Error.passwordMismatch))
            return
        }
        let parameters = [
            "email": email,
            "token": token,
            "password": password,
            "confirm_password": confirmPassword
        ]
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/reset-password", method: .post)
        let request = endPoint.request(body: parameters)
        urlSession.dataTask(request: request) { (result: Result<(ResponseMessage, Pagination?), Error>) in
            switch result {
            case .success((let response, _)):
                completion(.success(response.detail ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
