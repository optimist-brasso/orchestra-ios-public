//
//  KeyChainManager.swift
//  
//
//  Created by Mukesh Shakya on 11/01/2022.
//

import Foundation
import SwiftKeychainWrapper

public class KeyChainManager {
    
    //MARK: Properties
    public static let standard = KeyChainManager()
    
    //MARK: Functions
    public func set<T: Codable>(object: T, forKey key: String) {
        let encoded = KeyChainManager.standard.encode(object: object)
        KeychainWrapper.standard[KeychainWrapper.Key(rawValue: key)] = encoded
    }
    
    //GET ANY TYPE OF CODABLE OBJECT IN KEYCHAIN
    public func retrieve<T: Codable>(type: T.Type, forKey key: String) -> T? {
        let dataObject = KeychainWrapper.standard.data(forKey: key) ?? Data()
        return KeyChainManager.standard.decode(json: dataObject, as: type)
    }
    
    //CHCEK IF ANY TYPE OF CODABLE OBJECT IN KEYCHAIN IS AVAILABLE
    public func isAvailable<T: Codable> (type: T.Type, forKey key: String) -> Bool {
        let decoded = KeyChainManager.standard.retrieve(type: T.self, forKey: key)
        return decoded != nil
    }
    
    //CLEAR ANY TYPE OF CODABLE OBJECT IN KEYCHAIN IS AVAILABLE
    public func clear(_ key: String? = nil) {
        if let key = key {
            KeychainWrapper.standard.removeObject(forKey: key)
        } else {
            KeychainWrapper.standard.removeAllKeys()
        }
    }
    
}

