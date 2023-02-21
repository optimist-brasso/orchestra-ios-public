//
//  Cacher.swift
//  Orchestra
//
//  Created by manjil on 04/04/2022.
//

import Foundation

enum UserDefaultKey: String {
    
    case user = "user"
    case userInfo = "userInfo"
    case token = "token"
    case userDetail = "userDetail"
    case shownOnboarding,
         email,
         isAppPreviouslyOpen,
         isLogin,
         recordingSettings,
         streamingDownloadSettings,isVRInitialized
    
}

struct Cacher  {
    private let userDefault = UserDefaults()
    
    
    /// Method to archive the decodable object and then save into userdefaults
    ///
    /// - Parameters:
    ///   - object: the object to archive
    ///   - key: the cacheKey for identification of object storage
    /// - Returns: true if successfully archived and saved, false otherwise
    @discardableResult
    public func setValue<T>(type: T.Type, object: T, key: UserDefaultKey) -> Bool where T: Codable {
        do {
            let encodedValue = try JSONEncoder().encode(object)
            userDefault.setValue(encodedValue, forKey: key.rawValue)
            return userDefault.synchronize()
        } catch {
            return false
        }
    }

   /// Method that fetch and decode the top level object from cache
    ///
    /// - Parameter key: the cacheKey for identification of object storage
    /// - Returns: object if successfully decoded and fetched, nil otherwise
    public func value<T>(type: T.Type, forKey key: UserDefaultKey) -> T? where T: Codable {
        guard let data = userDefault.value(forKey: key.rawValue) as? Data else { return nil }
        do {
            let decodedValue = try JSONDecoder().decode(type.self, from: data)
            return decodedValue
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func setValue(_ value: Any, key: UserDefaultKey)  -> Bool {
        userDefault.setValue(value, forKey: key.rawValue)
        return userDefault.synchronize()
    }

    @discardableResult
    func get<T>(_ type: T.Type, forKey key: UserDefaultKey) -> T? {
         return userDefault.value(forKey: key.rawValue) as?  T
    }
    /// Deletes an object with the given key
    ///
    /// - Parameter key: the cache key
    /// - Returns: true if successfully deleted and synchronized
    @discardableResult
    public func delete(forKey key: UserDefaultKey) -> Bool {
        userDefault.removeObject(forKey: key.rawValue)
        return userDefault.synchronize()
    }
}

