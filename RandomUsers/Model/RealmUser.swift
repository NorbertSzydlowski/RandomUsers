//
//  RealmUser.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 12/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import RealmSwift

class RealmUser: Object {
    
    @objc dynamic var id: String    = ""
    @objc dynamic var name: String  = ""
    @objc dynamic var email: String = ""
    
    
    static func realmUser(userProtocol: UserProtocol) -> RealmUser {
        let user = RealmUser()
        user.setUserValues(userProtocol: userProtocol)
        return user
    }
    
    private func setUserValues(userProtocol: UserProtocol) {
        id      = userProtocol.getId()
        name    = userProtocol.getName()
        email   = userProtocol.getEmail()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

