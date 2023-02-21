//
//  SignupApi.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation

public protocol SignupApi {
    
    func signup(email: String,
                password: String,
                confirmPassword: String,
                additionalParams: [String: Any]?,
                completion: @escaping (Result<String, Error>) -> ())
    
}

public extension SignupApi {
    
    func signup(email: String,
                password: String,
                confirmPassword: String,
                additionalParams: [String: Any]? = nil,
                completion: @escaping (Result<String, Error>) -> ()) {
        guard password == confirmPassword else {
            completion(.failure(EK_GlobalConstants.Error.passwordMismatch))
            return
        }
        var parameters: [String: Any] = [
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword
        ]
        if let additionalParams = additionalParams, !additionalParams.isEmpty {
            additionalParams.forEach({
                parameters[$0.key] = $0.value
            })
        }
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/register", method: .post)
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
