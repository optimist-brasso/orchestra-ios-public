//
//  Recording.swift
//  Orchestra
//
//  Created by Prakash Chandra Awal on 7/14/22.
//

import Foundation
import Alamofire

protocol RecordingApi {
    
    func sendRecordedAudio(title: String, id: Int, date: String, duration: Int, file: AudioFile, completion: @escaping (Result<ResponseMessage, Error>) -> Void)
    
}


extension RecordingApi {
    
    func sendRecordedAudio(title: String, id: Int, date: String, duration: Int, file: AudioFile, completion: @escaping (Result<ResponseMessage, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 600
            sessionConfig.timeoutIntervalForResource = 600
            let urlSession = URLSession(configuration: sessionConfig)
            var paramaters: [String: Any] {
                var json: [String: Any] = [:]
                json["orchestra_id"] = String(id)
                json["title"] = title
                json["recording_date"] = date
                json["duration"] = String(duration)
                return json
            }
            let endPoint = EK_EndPoint(path: "recording", method: .post, needsAuthorization: true)
            let request = endPoint.request()
            var files = [URLSession.File]()
            files.append(URLSession.File(name: file.name, fileName:  file.fileName, data: file.data, contentType: file.contentType))
            urlSession.fileUpload(request: request, params: paramaters, files: files) { (result: Result<ResponseMessage, Error>) in
                //            guard let self = self  else { return}
                switch result {
                case .success((let model)):
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
