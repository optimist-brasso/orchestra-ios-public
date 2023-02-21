//
//  File.swift
//  
//
//  Created by ekmacmini43 on 06/01/2022.
//

import Foundation

public struct EK_Request {
    
    let request: URLRequest
    let endPoint: EK_EndPoint
    
    init(request: URLRequest, endPoint: EK_EndPoint) {
        self.request = request
        self.endPoint = endPoint
    }
    
    private func getKey(url: URL) -> String {
        let key = "\(url.scheme!)://\(url.host!)"
        if url.pathComponents.isEmpty {
            return key
        } else {
            return key + "/" + url.pathComponents.dropFirst().joined(separator: "/")
        }
    }
    
}
