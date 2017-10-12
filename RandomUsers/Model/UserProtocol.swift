//
//  User.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 10/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import ObjectMapper

private struct UserJSONConstants {
    static let userTitle    = "name.title"
    static let userFirst    = "name.first"
    static let userLast     = "name.last"
    static let userEmail    = "email"
    static let userId       = "login.md5"
    static let userPicture  = "picture.thumbnail"
}

protocol UserProtocol {
    
    func getId() -> String
    func getName() -> String
    func getEmail() -> String
    func getImageUrl() -> URL
}

class UserJson: Mappable, UserProtocol {
    
    private var title: String?
    private var first: String?
    private var last: String?
    
    private var email: String?
    
    private var id: String?
    private var picture: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title   <- map[UserJSONConstants.userTitle]
        first   <- map[UserJSONConstants.userFirst]
        last    <- map[UserJSONConstants.userLast]
        email   <- map[UserJSONConstants.userEmail]
        id      <- map[UserJSONConstants.userId]
        picture <- map[UserJSONConstants.userPicture]
    }
    
    func getId() -> String {
        return self.id!
    }
    
    func getName() -> String {
        return "\(self.title!) \(self.first!) \(self.last!)"
    }
    
    func getEmail() -> String {
        return email ?? ""
    }
    
    func getImageUrl() -> URL {
        return URL(string: picture!)!
    }
    
}
