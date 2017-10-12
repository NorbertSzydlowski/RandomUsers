//
//  Database.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 10/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import RealmSwift

protocol DatabaseProtocol {
    func save(user: UserProtocol)
    func delete(user: UserProtocol)
    func isSaved(user: UserProtocol) -> Bool
}

class Database: DatabaseProtocol {

    private let realm = try! Realm()
    
    func save(user: UserProtocol) {
        
        let user = RealmUser.realmUser(userProtocol: user)
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func delete(user: UserProtocol) {
        
        guard let realmUser = realmUserInDatabase(byPrimaryKey: user.getId()) else {
            return
        }
        
        try! realm.write {
            realm.delete(realmUser)
        }
    }
    
    func isSaved(user: UserProtocol) -> Bool {
        return realmUserInDatabase(byPrimaryKey: user.getId()) != nil
    }
    
    private func realmUserInDatabase(byPrimaryKey: String) -> RealmUser? {
        return realm.object(ofType: RealmUser.self, forPrimaryKey: byPrimaryKey)
    }
    
}
