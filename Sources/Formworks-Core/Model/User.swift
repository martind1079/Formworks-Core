//
//  User.swift
//  
//
//  Created by Martin Doyle on 21/02/2023.
//

import Foundation

public protocol UserStore {
    func loadUser(id: String) -> User?
    func save(user: User)
}

public class User {
    var savePasswordActivated: Bool?
    var savePasswordRefused: Bool?
    let username: String
    let loginDetails: [String: Any]
    var isAuthenticated: Bool
    var lastAlertId: String?
    var lastMetaDataId: String?
    var lastSyncId: String?
    var cameraRollAccessSave = 0
    var cameraRollAccessRead = 0
    var lastFormId: String?
    var lastLogin = 0
    var lastConnected = 0
    
    let userStore: UserStore
    
    public var confirmMessage: String? {
        loginDetails["confirm"] as? String
    }
    public var email: String {
        username
    }
    public var fullname: String {
        loginDetails["name"] as? String ?? ""
    }
    public var profileKey: String {
        guard let customerId = loginDetails["customerid"] as? String,
              let userId = loginDetails["userid"] as? String else { return "" }
        
        return customerId.appending("/\(userId)").appending("/Profile.json")
    }
    public var profile: String?
    
    public init(username: String, loginDetails: [String: Any], authenticated: Bool, userStore: UserStore) {
        self.username = username
        self.loginDetails = loginDetails
        self.isAuthenticated = authenticated
        self.userStore = userStore
    }
    
    public func save() {
        userStore.save(user: self)
    }
    
    public func canSavePassword() -> Bool {
        true
    }
    
    public func clientId() -> String {
        return loginDetails["clientid"] as! String
    }
    
    public func customerId() -> String {
        return loginDetails["customerid"] as! String
    }
}
