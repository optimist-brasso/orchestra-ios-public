//
//  DownloadCountApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 03/02/2023.
//

import Foundation
import Alamofire

protocol DownloadCountApi {
    
    func updateDownloadCount(completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}

extension DownloadCountApi {
    
    func updateDownloadCount(completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "download-count", method: .post)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(ResponseMessage, Pagination?), Error>) in
                switch result {
                case .success((let model, _)):
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
