//
//  LoginModel.swift
//  FormworksThe Revenge
//
//  Created by Martin Doyle on 08/02/2023.
//

import Foundation

public struct UserDetails {
    public let username: String
    public let loginDetails: [String: Any]
    public let authenticated: Bool
    
    public init(username: String, loginDetails: [String : Any], authenticated: Bool) {
        self.username = username
        self.loginDetails = loginDetails
        self.authenticated = authenticated
    }
}

public enum LoginError: Error {
    case auth0Error
    case offlineNoUser
    case serverError(message: String)
}

public struct LoginResponse {
    public let userDetails: UserDetails
    public let requirePin: Bool
    public let createPin: Bool
    
    public init(details: UserDetails, requirePin: Bool = false, createPin: Bool = false) {
        self.userDetails = details
        self.requirePin = requirePin
        self.createPin = createPin
    }
}

public enum LoginResult {
    case success(response: LoginResponse)
    case failure(error: LoginError)
}

public protocol LoginService {
    func login(username: String?, completion: @escaping (LoginResult) -> Void)
    func currentAccessToken(completion: @escaping (String?) -> Void)
}
