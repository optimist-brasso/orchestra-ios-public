//
//  Configuration.swift
//  
//
//  Created by Mukesh Shakya on 06/01/2022.
//

import Foundation

public struct Configuration {
    
    public let clientId: String
    public let clientSecret: String
    public let baseURL: String
    var eklogUsername: String?
    var eklogPassword: String?
    var eklogDomain: String?
    
    public static var conf: Configuration?
    
    public init(clientId: String,
                clientSecret: String,
                baseURL: String,
                eklogUsername: String? = nil,
                eklogPassword: String? = nil,
                eklogDomain: String? = nil) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.baseURL = baseURL
        self.eklogUsername = eklogUsername
        self.eklogPassword = eklogPassword
        self.eklogDomain = eklogDomain
    }
    
}
