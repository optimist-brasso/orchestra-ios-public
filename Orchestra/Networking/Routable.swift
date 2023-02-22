//
//  Routable.swift
//  Orchestra
//
//  Created by manjil on 01/04/2022.
//

import Foundation
import Alamofire


enum Environment {
    static func getServerUrl() -> URL {
        let confURL = Configuration.conf?.baseURL ?? ""
        guard let url = URL(string: "\(confURL)/") else { fatalError("The base url is invalid") }
        
        return url
    }
}

public protocol Routable: URLRequestConvertible {
    
    /// The headers required for every requests
    var headers: [String: String] { get }
    
    /// Need tokenValidation: flag to indicate that when request is perform the token validity is test first
    var needTokenValidation: Bool { get }
    
    var httpMethod: Alamofire.HTTPMethod { get }
    
    /// request URL
    static var baseUrl: URL { get }
}

public extension Routable {
    
    /// Authorization header is put through here to each router
    var headers: [String: String] {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["client_id"] =  Configuration.conf?.clientId ?? ""
        headers["client_secret"] = Configuration.conf?.clientSecret ?? ""
        return headers
    }
    
    /// indicator to indicate that a router will attempt to add token to header when requesting service
    var needTokenValidation: Bool { return true }
    /// The base url of the endpoint
    static var baseUrl: URL { return Environment.getServerUrl() }
}


