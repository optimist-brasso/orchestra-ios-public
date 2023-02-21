//
//  ChangePasswordApi.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation

public protocol ChangePassowrdApi {
    
    func changePassword(oldPassword: String,
                        newPassword: String,
                        confirmPassword: String,
                        completion: @escaping (Result<String, Error>) -> ())
    
}

public extension ChangePassowrdApi {
    
    func changePassword(oldPassword: String,
                        newPassword: String,
                        confirmPassword: String,
                        completion: @escaping (Result<String, Error>) -> ()) {
        if newPassword != confirmPassword {
            completion(.failure(EK_GlobalConstants.Error.passwordMismatch))
            return
        }
        let parameters = [
            "old_password": oldPassword,
            "new_password": newPassword,
            "confirm_password": confirmPassword
        ]
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/change-password", method: .post, needsAuthorization: true)
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
