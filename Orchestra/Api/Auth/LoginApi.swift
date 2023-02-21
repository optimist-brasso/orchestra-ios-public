//
//  LoginApi.swift
//  
//
//  Created by Mukesh Shakya on 07/01/2022.
//

import Foundation

public protocol LoginApi {
    
    func login(email: String,
               password: String,
               completion: @escaping (Result<AuthModel, Error>) -> ())
    
}

public extension LoginApi {
    
    func login(email: String,
               password: String,
               completion: @escaping (Result<AuthModel, Error>) -> ()) {
        let parameters: [String: Any] = [
            "client_id": Configuration.conf?.clientId ?? "",
            "client_secret": Configuration.conf?.clientSecret ?? "",
            "grant_type": Provider.pasword.rawValue,
            "email": email,
            "password": password
        ]
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/login", method: .post)
        let request = endPoint.request(body: parameters)
        urlSession.dataTask(request: request) { (result: Result<(AuthModel, Pagination?), Error>) in
            switch result {
            case .success((let authModel, _)):
                authModel.date = Date()
                authModel.isFromSocialMedia = false
                authModel.expiresIn = 300
                KeyChainManager.standard.set(object: authModel, forKey: EK_GlobalConstants.authKey)
                completion(.success(authModel))
            case .failure(let error):
                completion(.failure(NSError(domain:  "login-error", code: 22, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
            }
        }
    }

}
