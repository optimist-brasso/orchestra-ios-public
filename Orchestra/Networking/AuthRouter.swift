//
//  AuthRouter.swift
//  Orchestra
//
//  Created by manjil on 13/04/2022.
//

import Foundation
import Alamofire

enum AuthRouter: Routable {
    
    case sendActivationToken(Parameters)
    case tokenVerification(Parameters)
    case appInfo
    case resendActivationCode(Parameters)
    case register(file: File, parameters: Parameters)
    var path: String {
        switch self {
        case .sendActivationToken:
            return "auth/send-activation-token"
        case .tokenVerification:
            return "auth/token-verification"
        case .appInfo:
            return "app-info"
        case .resendActivationCode:
            return "auth/resend-activation-token"
        case .register:
            return "auth/register"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .appInfo:
            return .get
        default:
            return .post
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: AuthRouter.baseUrl.appendingPathComponent(path))
        urlRequest.httpMethod = httpMethod.rawValue
        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        switch self {
        case .sendActivationToken(let parameter), .tokenVerification(let parameter), .resendActivationCode(let parameter):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameter)
        case .appInfo, .register(file: _, parameters: _):
             break
        }
        return urlRequest
        
    }
}
