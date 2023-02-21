//
//  DatabaseHandler.swift
//  Orchestra
//
//  Created by manjil on 05/04/2022.
//

import Foundation
import RealmSwift
private let sharedInstance = DatabaseHandler()

class DatabaseHandler {
    
    private var realmConfiguration = Realm.Configuration()
//    private var realm: Realm?
    
    fileprivate init() { /**  fileprivate init */  }
   
    class var shared: DatabaseHandler {
        return sharedInstance
    }
    
    @discardableResult
    private func getReamInstance() -> Realm? {
        //        if let realm = realm {
        //            return realm
        //        } else {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            //                getActiveUser()
            return realm
        } catch (let error) {
            print(error)
            return nil
        }
        //        }
    }
    
    /**
     Method to migrate the pre-populated realm database
     */
    func prepare() -> Bool {
        let appName = "Orchestra"
        if let defaultURL = Realm.Configuration.defaultConfiguration.fileURL {
            let appRealmURL = defaultURL.deletingLastPathComponent().appendingPathComponent("\(appName).realm")
            if !FileManager.default.fileExists(atPath: appRealmURL.path) {
                
                realmConfiguration.fileURL = appRealmURL
                // Realm.Configuration.defaultConfiguration = realmConfiguration
                _ = try? Realm(configuration: realmConfiguration)
//                print(Realm.Configuration.defaultConfiguration.fileURL ?? "No file")
            } else {
               // _ = try? Realm(configuration: realmConfiguration)
                realmConfiguration.fileURL = appRealmURL
            }
//            print("path -->")
//            print(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "No file")
        }
       return false
    }
    
    
    func writeObjects(with objects: [Object]) {
        do {
            guard let realm = getReamInstance() else {
                return
            }
            try realm.write {
                realm.add(objects, update: Realm.UpdatePolicy.all)
            }
        } catch(let error) {
            print("Exception while writing to database : \(error.localizedDescription)")
            // databaseSyncCompleted(success: false)
        }
    }
    
    func fetch<T: Object>(primaryKey: Any) -> T? {
        guard let realm = getReamInstance() else {
            return nil
        }
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
    func fetch<T: Object>() -> [T] {
        guard let realm = getReamInstance() else {
            return []
        }
        let values = realm.objects(T.self)
        return Array(values)
    }
    
    func fetch<T: Object>(object: T.Type, predicate: NSPredicate? = nil, filter: String = "")  -> Results<T>? {
            guard let realm = getReamInstance() else {
                return nil
            }
            let object = realm.objects(object)
            if let predicate = predicate {
                return  object.filter(predicate)
            }
            if !filter.isEmpty  {
                return object.filter(filter)
            }
            return object
    }
    
    func fetch<T: Object>(filter: String) -> [T] {
        guard let realm = getReamInstance() else {
            return []
        }
        var value = realm.objects(T.self)
        if !filter.isEmpty {
            value = value.filter(filter)
        }
        return Array(value)
    }
    
    func delete(object: [Object]) {
        guard let realm = getReamInstance() else {
            return
        }
        do {
           try  realm.write {
                realm.delete(object)
            }
        } catch(let error) {
            print(error)
        }
    }
    
    func deleteAll()  {
        guard let realm = getReamInstance() else {
            return
        }
        do {
           try  realm.write {
               realm.deleteAll()
               
            }
        } catch(let error) {
            print(error)
        }
    }
    
    func getBackgroundReamInstance(completion: @escaping ((Realm?) -> Void)) {
        DispatchQueue.global(qos: .background).async {  [weak self ] in
            guard let self = self else {
                completion(nil)
                return
            }
            do {
                let realm = try Realm(configuration: self.realmConfiguration)
                 completion(realm)
            } catch (let error) {
                print(error)
                completion(nil)
            }
        }
    }
    
    func fetch<T: Object>(object: T.Type, predicate: NSPredicate? = nil, filter: String = "", completion: @escaping ((Results<T>?) -> ()) ) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                completion(nil)
                return
            }
            self.getBackgroundReamInstance { realm in
                guard let realm = realm else {
                    completion(nil)
                    return
                }
                let object = realm.objects(object)
                if let predicate = predicate {
                    let data =  object.filter(predicate)
                    completion(data)
                    return
                }
                if !filter.isEmpty  {
                    let data = object.filter(filter)
                    completion(data)
                    return
                }
                completion(object)
             }
        }
    }
    
    func update(action: () -> ()) {
        guard let realm = getReamInstance() else {
            return
        }
        realm.beginWrite()
        do {
            action()
            try realm.commitWrite()
        } catch {
            if realm.isInWriteTransaction { realm.cancelWrite() }
        }
    }
    
}
