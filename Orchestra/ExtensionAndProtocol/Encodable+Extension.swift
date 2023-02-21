//
//  Encodable+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/05/2022.
//

import Foundation

extension Encodable {

    var dictionary : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
    var JSONString: String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
