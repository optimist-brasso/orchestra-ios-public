//
//  ProfileApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import Foundation
import Alamofire

protocol ProfileApi {
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    
}

extension ProfileApi {
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "user/profile", method: .get, needsAuthorization: true)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(Profile, _), Error>) in
                switch result {
                case .success((let model, _)):
                    let profiles: [Profile] = DatabaseHandler.shared.fetch()
                    DatabaseHandler.shared.delete(object: profiles)
                    DatabaseHandler.shared.writeObjects(with: [model])
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
