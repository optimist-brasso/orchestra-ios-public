//
//  SignupServiceType.swift
//  Orchestra
//
//  Created by Rojan Shrestha on 14/02/2022.
//
//

import Foundation


protocol SignupServiceType: AnyObject, SocialLoginApi, RegisterFCMApi {
    
    func socialApiRequest(token: String,
                          userId: String,
                          username: String,
                          type: Provider,
                          completion: @escaping(Result<String, Error>) -> Void)
    
}
