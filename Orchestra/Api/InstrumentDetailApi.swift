//
//  InstrumentDetailApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 24/06/2022.
//

import Foundation
import Alamofire

protocol InstrumentDetailApi {
    
    func fetchInstrumentDetail(of id: Int, in orchestraId: Int, musicianId: Int, completion: @escaping (Result<Instrument, Error>) -> Void)
    
}

extension InstrumentDetailApi {
    
    func fetchInstrumentDetail(of id: Int, in orchestraId: Int, musicianId: Int, completion: @escaping (Result<Instrument, Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "instrument-detail/\(id)", method: .get)
            URLSession.shared.dataTask(request: endPoint.request(body: ["orchestra_id": "\(orchestraId)", "musician_id": "\(musicianId)"])) { (result: Result<(Instrument, Pagination?), Error>) in
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
