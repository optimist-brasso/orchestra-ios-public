//
//  File.swift
//  
//
//  Created by ekmacmini43 on 06/01/2022.
//

import Foundation

protocol Container: Codable {
    
    var errors: [ResponseMessage]? { get }
    var hasData: Bool { get }
    
}
