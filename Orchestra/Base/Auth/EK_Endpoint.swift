//
//  File.swift
//  
//
//  Created by ekmacmini43 on 06/01/2022.
//

import Foundation
import Alamofire

public class EK_EndPoint {
    
    var needsAuthorization: Bool = false
    let path: String
    let method: HTTPMethod
    
    public init(path: String, method: HTTPMethod, needsAuthorization: Bool? = nil) {
        self.path = path
        self.method = method
        self.needsAuthorization = needsAuthorization ?? (Auth.shared.oAuth != nil)
    }
    
    private func request(urlString: String, body: [String: Any]? = nil) -> EK_Request {
        var components = URLComponents(string: urlString)!
        if method.rawValue == "GET" {
            components.queryItems = body?.map({ (key, value) in
                URLQueryItem(name: key, value: value as? String)
            })
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        if method.rawValue == "POST" || method.rawValue == "DELETE" || method.rawValue == "PUT"  {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let body = body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            }
        }
        request.setValue(UserDefaults.standard.string(forKey: "LCLCurrentLanguageKey") ?? Locale.current.languageCode, forHTTPHeaderField: "Accept-Language")
        return EK_Request(request: request, endPoint: self)
    }
    
    public func request(body: [String: Any]? = nil) -> EK_Request {
        let urlString = (Configuration.conf?.baseURL ?? "") + "/" + path
        return request(urlString: urlString, body: body)
    }
    
}
