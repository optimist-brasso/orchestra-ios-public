//
//  KeyChainManager+Extension.swift
//  
//
//  Created by ekmacmini43 on 11/01/2022.
//

import Foundation

extension KeyChainManager {

    func encode<T: Codable>(object: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(object)
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    func decode<T: Decodable>(json: Data, as clazz: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: json)
            return data
        } catch {
            print("An error occurred while parsing JSON")
        }
        return nil
    }
    
}
