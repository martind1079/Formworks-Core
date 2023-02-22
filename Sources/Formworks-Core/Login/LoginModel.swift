//
//  LoginModel.swift
//  FormworksThe Revenge
//
//  Created by Martin Doyle on 08/02/2023.
//

import Foundation

public struct LoginDetails {
    public let username: String
    public let userDetails: [String: Any]
    public let authenticated: Bool
    
    public init(username: String, userDetails: [String : Any], authenticated: Bool) {
        self.username = username
        self.userDetails = userDetails
        self.authenticated = authenticated
    }
}

public enum LoginError: Error {
    case auth0Error
    case offlineNoUser
    case serverError(message: String)
}

public struct LoginResponse {
    public let loginDetails: LoginDetails
    public let requirePin: Bool
    public let createPin: Bool
    
    public init(loginDetails: LoginDetails, requirePin: Bool = false, createPin: Bool = false) {
        self.loginDetails = loginDetails
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
