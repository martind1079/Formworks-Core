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
    var userDetails: UserDetails
    public var isAuthenticated = false
    let userStore: UserStore
    var loginDetails: [String: Any]
    
    public var confirmMessage: String? {
        loginDetails["confirm"] as? String
    }
    public var email: String {
        userDetails.username
    }
    public var fullname: String {
        userDetails.fullName
    }
    public var profileKey: String {
        customerId.appending("/\(userDetails.userId)").appending("/Profile.json")
    }
    public var profile: String?
    
    public init(username: String, loginDetails: [String: Any], authenticated: Bool, userStore: UserStore) {
        self.loginDetails = loginDetails
        self.isAuthenticated = authenticated
        self.userStore = userStore
        userDetails = UserDetails(username: username, loginDetails: loginDetails)
        save()
    }
    
    public func setLoginDetails(details: [String: Any]) {
        loginDetails = details
        userDetails.update(loginDetails: details)
        save()
    }
    
    public func savePasswordRefused() {
        userDetails.savePasswordRefused = false
        save()
    }
    
    public func savePasswordAccepted() {
        userDetails.savePasswordActivated = true
        save()
    }
    
    private func save() {
        userStore.save(user: self)
    }
    
    public func canSavePassword() -> Bool {
        userDetails.savePasswordAllowed && userDetails.savePasswordRefused == false && userDetails.savePasswordActivated == false
    }
    
    public var clientId: String {
        userDetails.clientId
    }
    
    public var customerId: String {
        userDetails.customerId
    }
}
