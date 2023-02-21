//
//  RecordingListApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 10/05/2022.
//

import Foundation
import Alamofire

protocol RecordingListApi {
    
    func fetchRecordingList(of page: Int, keyword: String?, completion: @escaping (Result<(models: [Recording], totalPages: Int), Error>) -> Void)
    
}

extension RecordingListApi {
    
    func fetchRecordingList(of page: Int = 1, keyword: String? = nil, completion: @escaping (Result<(models: [Recording], totalPages: Int), Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "recording", method: .get, needsAuthorization: true)
            var parameters = ["page": "\(page)"]
            if let keyword = keyword, !keyword.isEmpty {
                parameters["keyword"] = keyword
            }
            URLSession.shared.dataTask(request: endPoint.request(body: parameters)) { (result: Result<([Recording], Pagination?), Error>) in
                switch result {
                case .success((let models, let pagination)):
                    completion(.success((models, pagination?.totalPages ?? 1)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
