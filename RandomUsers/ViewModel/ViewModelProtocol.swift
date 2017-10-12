//
//  ViewModel.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 10/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {
    
    var reloadViewCallback : (()->())! { get set }
    func fetchData()
    func size() -> Int
    func searchTextDidChange(text: String)
    func itemAtIndex(index: Int, callback: ((UserProtocol, Bool)->()))
    func changeStateInDatabase(index: Int, callback: ((Bool)->()))
}

class ViewModel: NSObject, ViewModelProtocol {
    
    var reloadViewCallback : (()->())!
    
    private var users: Array<UserProtocol> = Array() {
        didSet {
            refilter()
        }
    }
    private var filteredUsers: Array<UserProtocol> = Array() {
        didSet {
            reloadViewCallback()
        }
    }
    
    private var hintText = "" {
        didSet {
            refilter()
        }
    }
    
    private func refilter() {
        if (hintText.isEmpty) {
            self.filteredUsers = Array(users)
        } else {
            self.filteredUsers = users.filter({ user -> Bool in
                return user.getName().contains(hintText) || user.getEmail().contains(hintText)
            })
            
        }
    }
    
    private let networkDataProvider: APIProtocol
    private let localDataProvider: DatabaseProtocol
    
    init(networkDataProvider: APIProtocol, localDataProvider: DatabaseProtocol, reloadViewCallback: @escaping ()->()) {
        self.networkDataProvider = networkDataProvider
        self.localDataProvider   = localDataProvider
        self.reloadViewCallback  = reloadViewCallback
    }
    
    func fetchData() {
        
        _ = self.networkDataProvider.users(size: 100, success: { users in
            self.users = users
        }) { error in
            
        }
        
        
    }
    
    func size() -> Int {
        return self.filteredUsers.count
    }
    
    func itemAtIndex(index: Int, callback: ((UserProtocol, Bool) -> ())) {
        
        let user = self.filteredUsers[index]
        callback(user, self.localDataProvider.isSaved(user: user))
    }
    
   
    
    func searchTextDidChange(text: String) {
        self.hintText = text
    }
    
    func changeStateInDatabase(index: Int, callback: ((Bool) -> ())) {
        let user = self.filteredUsers[index]
        let isSaved = self.localDataProvider.isSaved(user: user)
        
        if(isSaved) {
            self.localDataProvider.delete(user: user)
        } else {
            self.localDataProvider.save(user: user)
        }
        
        callback(!isSaved)
    }
}


