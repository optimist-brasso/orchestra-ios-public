//
//  AppInfoManager.swift
//  Orchestra
//
//  Created by manjil on 07/04/2022.
//

import Foundation
import Combine

class AppInfoManager {
    
    var bag = Set<AnyCancellable>()
    let networking = Networking()
    
   private let databaseHandler = DatabaseHandler.shared
    
    let urlSession = URLSession.shared
    
    public func request(completionHandeler: @escaping(Error?) -> Void) {
        networking.request(type: AppInfo.self, router: AuthRouter.appInfo)
            .receive(on: RunLoop.main)
            .subscribe(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else {
                    return
                }
                self.inferredResponse(response: response, router: AuthRouter.appInfo)
                completionHandeler(response.error.description.isEmpty ? nil : response.error)
            }.store(in: &bag)
    }
    
    private func inferredResponse(response: NetworkingResult<DataParser<AppInfo>>, router: Routable){
        /// we intercept login router to save the user inside cache
        switch router {
        case AuthRouter.appInfo:
            if let data = response.object?.data {
                databaseHandler.writeObjects(with: [data])
            }
        default: break
        }
    }
    
    /// Deinitializer
    deinit {
        print("De-Initialized \(String(describing: self))")
    }
    
}






