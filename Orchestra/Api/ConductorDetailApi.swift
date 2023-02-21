//
//  ConductorDetailApi.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import Foundation

protocol ConductorDetailApi {
    
    func fetchConductorDetail(of id: Int, completion: @escaping (Result<Orchestra, Error>) -> ())
    
}

extension ConductorDetailApi {
    
    func fetchConductorDetail(of id: Int, completion: @escaping (Result<Orchestra, Error>) -> ()) {
        let endPoint = EK_EndPoint(path: "orchestra/\(id)", method: .get)
        URLSession.shared.dataTask(request: endPoint.request()) { (result: Result<(Orchestra, _), Error>) in
            switch result {
            case .success((let model, _)):
//                let oldRealmModel: Orchestra? = DatabaseHandler.shared.fetch(primaryKey: id)
//                DatabaseHandler.shared.update {
//                    if !(oldRealmModel?.vrPath?.isEmpty ?? true) {
//                        model.vrFile = oldRealmModel?.vrPath
//                    }
//                    model.vrPath = oldRealmModel?.vrPath
//                }
//                DatabaseHandler.shared.writeObjects(with: [model])
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
