//
//  OrchestraInstrumentApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 28/06/2022.
//

import Foundation
import Alamofire

protocol OrchestraInstrumentApi {
    
    func fetchOrchestraInstrument(of id: Int, completion: @escaping (Result<[Instrument], Error>) -> Void)
    
}

extension OrchestraInstrumentApi {
    
    func fetchOrchestraInstrument(of id: Int, completion: @escaping (Result<[Instrument], Error>) -> Void) {
        if NetworkReachabilityManager()?.isReachable == true {
            let endPoint = EK_EndPoint(path: "orchestra-instrument-list/\(id)", method: .get)
            URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<([Instrument], Pagination?), Error>) in
                switch result {
                case .success((let models, _)):
                    completion(.success(models))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(GlobalConstants.Error.noInternet))
        }
    }
    
}
