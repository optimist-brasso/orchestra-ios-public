//
//  AppleAuthManager.swift
//  Orchestra
//
//  Created by manjil on 25/04/2022.
//

import Foundation
import AuthenticationServices
import Combine

public enum AppleAuthError: LocalizedError {
    case canceled
    case other(Error)
    case custom(String)
    
   public var errorDescription: String? {
        switch self {
        case .other( let error):
            return error.localizedDescription
        case .custom(let errorText):
            return errorText
        default:
            return ""
        }
    }
}

/// The structure of the data we get from doing apple login
public struct AppleUser: Codable {
    
    /// The userId
    public var userId: String
    
    /// The authorization token
  //  public var authToken: String
    
    /// the idToken for apple login
    public var idToken: String
    
    /// FirstName of the user
    public var firstName: String
    
    /// LastName of the user
    public var lastName: String
    
    /// The email of the user
    public var email: String?
    
}


public final class AppleAuthManager: NSObject {
    
    
    /// The apple ID Provider
    private let appleIDProvider: ASAuthorizationAppleIDProvider
    
    /// The request with provider
    private let request: ASAuthorizationAppleIDRequest
    
    /// auth instance for the request
    private let authorizationController: ASAuthorizationController
    
    /// The publisher for apple auth
    public let appleResponse = PassthroughSubject<Result<AppleUser, AppleAuthError>, Never>()
    
    /// Initializer
    public init(appleIDProvider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()) {
        self.appleIDProvider = appleIDProvider
        self.request = appleIDProvider.createRequest()
        self.authorizationController = ASAuthorizationController(authorizationRequests: [request])
    }
    
    /// Method to check if we have valid apple login session
//    public func isAppleAuthorized(completion: @escaping (Bool) -> Void) {
//        guard let appleUser = cacheManager.getObject(type: AppleUser.self, forKey: FrameworkCacheKey.appleUser) else { completion(false); return }
//        appleIDProvider.getCredentialState(forUserID: appleUser.userId) { (state, error) in
//            switch state {
//            case .authorized:
//                completion(true)
//            default:
//                completion(false)
//            }
//        }
//    }
    
    public func isLoggedIn() -> Bool {
       // cacheManager.getObject(type: AppleUser.self, forKey: FrameworkCacheKey.appleUser) != nil
        false
    }
    
    /// Remove the credentials for apple user
    public func logout() -> Bool {
        return  false //cacheManager.delete(forKey: FrameworkCacheKey.appleUser)
    }
    
    public func performLogin(from provider: ASAuthorizationControllerPresentationContextProviding) {
        
        // set the request operation
        request.requestedOperation = .operationLogin
        
        //set the scopes
        request.requestedScopes = [.fullName, .email]
        
        // start the auth flow
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = provider
        authorizationController.performRequests()
    }
}

extension AppleAuthManager : ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        var applAuthError: AppleAuthError = .other(error)
        if let authError = error as? ASAuthorizationError,
        authError.code == ASAuthorizationError.canceled || authError.code == ASAuthorizationError.unknown {
            applAuthError = .canceled
        }
        appleResponse.send(.failure(applAuthError))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            /// check if we have proper login token
            guard let token = appleIDCredential.identityToken,
                let identityTokenString = String(data: token, encoding: .utf8)
            //    let authData = appleIDCredential.authorizationCode
           // let authToken = String(data: authData, encoding: .utf8)
            else {
                appleResponse.send(.failure(.custom("Unable to verify identity for your apple account. Please try again later")))
                return
            }
            
            //set the result if we have info
            let firstName = appleIDCredential.fullName?.givenName ?? ""
            let email = appleIDCredential.email
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            
            //set the uerinfo from cache for subsequent requests
//            if let appleUser = cacheManager.getObject(type: AppleUser.self, forKey: FrameworkCacheKey.appleUser) {
//                if firstName.isEmpty {
//                    firstName = appleUser.firstName
//                }
//
//                if lastName.isEmpty {
//                    lastName = appleUser.lastName
//                }
//
//                if email == nil {
//                    email = appleUser.email
//                }
//            }
            
            // set the credential info
            let credentialInfo = ["userId": appleIDCredential.user,
                                   // "authToken": authToken,
                                    "idToken": identityTokenString,
                                    "firstName": firstName ,
                                    "lastName": lastName,
                                    "email": email]
            
            // create the apple user data
            do {
                let data = try JSONSerialization.data(withJSONObject: credentialInfo, options: .prettyPrinted)
                let appleUser = try JSONDecoder().decode(AppleUser.self, from: data)
                
                //persists this in keychain
//                cacheManager.saveObject(type: AppleUser.self, object: appleUser, key: FrameworkCacheKey.appleUser)
                //trigger the user data to listener
                appleResponse.send(.success(appleUser))
            } catch {
                appleResponse.send(.failure(.custom("Unable to verify identity for your apple account. Please try again later")))
            }
        } else {
            appleResponse.send(.failure(.custom("Unable to use apple id for authorization at the moment. Please try again later")))
        }
    }
}
