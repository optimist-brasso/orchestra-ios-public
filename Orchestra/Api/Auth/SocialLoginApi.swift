//
//  SocialLoginApi.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation

public protocol SocialLoginApi {
    
    func socialLogin(accessToken: String,
                     userIdentifier: String?,
                     name: String?,
                     type: Provider,
                     completion: @escaping (Result<AuthModel, Error>) -> ())
    
}

public extension SocialLoginApi {
    
    /*!
        @function   socialLogin
        @abstract   Saves auth model

        @param      accessToken
                    Required during facebook, line, google, twitter, apple (string encoded value of identityToken attribute in ASAuthorizationAppleIDCredential)

        @param      userIdentifier
                    Required only during apple login (user attribute in ASAuthorizationAppleIDCredential)

        @param      name
                    Required only during apple login

        @param      type
                    Provider enum raw value
    */
    func socialLogin(accessToken: String,
                     userIdentifier: String? = nil,
                     name: String? = nil,
                     type: Provider,
                     completion: @escaping (Result<AuthModel, Error>) -> ()) {
        var parameters = [
            "client_id": Configuration.conf?.clientId ?? "",
            "client_secret": Configuration.conf?.clientSecret ?? "",
            "grant_type": "social",
            "type": type.rawValue,
            "access_token": accessToken
        ]
        if let userIdentifier = userIdentifier {
            parameters["user_identifier"] = userIdentifier
        }
        if let name = name {
            parameters["name"] = name
        }
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/social-login", method: .post)
        let request = endPoint.request(body: parameters)
        urlSession.dataTask(request: request) { (result: Result<(AuthModel, Pagination?), Error>) in
            switch result {
            case .success((let authModel, _)):
                authModel.date = Date()
                authModel.isFromSocialMedia = true
                KeyChainManager.standard.set(object: authModel, forKey: EK_GlobalConstants.authKey)
                completion(.success(authModel))
            case .failure(let error):
                completion(.failure(NSError(domain:  "social-login-error", code: 22, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
            }
        }
    }
    
}
