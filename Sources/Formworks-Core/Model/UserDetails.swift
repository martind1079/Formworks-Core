//
//  UserDetails.swift
//  
//
//  Created by Martin Doyle on 22/02/2023.
//

import Foundation

public struct UserDetails {
    public var username: String
    public var currentUser: Int = 1
    public var customerId: String
    public var clientId: String
    public var customerName: String
    public var fullName: String
    public var syncId: String
    public var lastLogin: Int = 0
    public var lastSyncId: Int = 0
    public var savePasswordAllowed: Bool
    public var savePasswordActivated: Bool
    public var savePasswordRefused: Bool
    public var lastFormId: String?
    public var lastConnected: Int
    public var userId: String
    public var lastMetaDataId: Int
    public var lastAlertId: Int
    public var cameraRollAccessSave: Bool
    public var cameraRollAccessRead: Bool
    
    let response = """
    logindetails =     {
        cameraRollAccessRead = 1;
        cameraRollAccessSave = 1;
        cansavepassword = True;
        clientid = "62b35cb2-99e8-4b28-988f-983834a6fbb7";
        customerid = "f9de0682-c22e-41d6-b106-ce5bc1ce7dc2";
        customername = "UAT Customer";
        entitlements =         {
            AccessFormAfterSubmission = 1;
            AllowWebForms = 1;
            Audio = 1;
            AutomatedPreFill = 1;
            ExportToBIM360 = 1;
            ExportToDropbox = 1;
            ExportToExcel = 1;
            ExportToWebService = 1;
            Handwriting = 0;
            Notifications = 1;
            PrefilledForms = 1;
            StrongPasswords = 0;
            Tables = 1;
            ValidationScripts = 1;
        };
        handwritinglicenced = True;
        name = "Martin Doyle TP";
        syncid = "56f9523f-c3a9-4aaf-8b34-9b4c458a75ef";
        useCrashReporting = False;
        userid = "6f368e5e-ef0e-4b82-a926-8af6cf75ff72";
    };
"""
    
    public init(username: String, loginDetails: [String: Any]) { //  A new user, can set everything
        self.username = username
        if let cameraRead = loginDetails["cameraRollAccessRead"] as? Int {
            cameraRollAccessRead = cameraRead == 1 ? true : false
        } else {
            cameraRollAccessRead = false
        }
        if let cameraSave = loginDetails["cameraRollAccessSave"] as? Int {
            cameraRollAccessSave = cameraSave == 1 ? true : false
        } else {
            cameraRollAccessSave = false
        }
        if let clientId = loginDetails["clientid"] as? String {
            self.clientId = clientId
        } else {
            self.clientId = ""
        }
        if let customerId = loginDetails["customerid"] as? String {
            self.customerId = customerId
        } else {
            self.customerId = ""
        }
        
        if let customerName = loginDetails["customername"] as? String {
            self.customerName = customerName
        } else {
            self.customerName = ""
        }
        if let fullName = loginDetails["name"] as? String {
            self.fullName = fullName
        } else {
            self.fullName = ""
        }
        if let syncId = loginDetails["syncid"] as? String {
            self.syncId = syncId
        } else {
            self.syncId = ""
        }
        if let savePasswordAllowed = loginDetails["cansavepassword"] as? Bool {
            self.savePasswordAllowed = savePasswordAllowed
        } else {
            self.savePasswordAllowed = false
        }
        if let savePasswordActivated = loginDetails["savepasswordactivated"] as? Bool {
            self.savePasswordActivated = savePasswordActivated
        } else {
            self.savePasswordActivated = false
        }
        if let savePasswordRefused = loginDetails["savepasswordrefused"] as? Bool {
            self.savePasswordRefused = savePasswordRefused
        } else {
            self.savePasswordRefused = false
        }
        if let lastFormId = loginDetails["lastformid"] as? String {
            self.lastFormId = lastFormId
        } else {
            self.lastFormId = nil
        }
        if let lastConnected = loginDetails["lastconnected"] as? Int {
            self.lastConnected = lastConnected
        } else {
            self.lastConnected = 0
        }
        if let userId = loginDetails["userid"] as? String {
            self.userId = userId
        } else {
            self.userId = ""
        }
        if let lastMetaDataId = loginDetails["lastmetadataid"] as? Int {
            self.lastMetaDataId = lastMetaDataId
        } else {
            self.lastMetaDataId = 0
        }
        if let lastAlertId = loginDetails["lastalertid"] as? Int {
            self.lastAlertId = lastAlertId
        } else {
            self.lastAlertId = 0
        }
    }
    
    mutating public func update(loginDetails: [String: Any]) { // updating a loaded user from login, ony set the non changable items
        if let cameraRead = loginDetails["cameraRollAccessRead"] as? Int {
            cameraRollAccessRead = cameraRead == 1 ? true : false
        } else {
            cameraRollAccessRead = false
        }
        if let cameraSave = loginDetails["cameraRollAccessSave"] as? Int {
            cameraRollAccessSave = cameraSave == 1 ? true : false
        } else {
            cameraRollAccessSave = false
        }
        if let clientId = loginDetails["clientid"] as? String {
            self.clientId = clientId
        } else {
            self.clientId = ""
        }
        if let customerId = loginDetails["customerid"] as? String {
            self.customerId = customerId
        } else {
            self.customerId = ""
        }
        
        if let customerName = loginDetails["customername"] as? String {
            self.customerName = customerName
        } else {
            self.customerName = ""
        }
        if let fullName = loginDetails["name"] as? String {
            self.fullName = fullName
        } else {
            self.fullName = ""
        }
        if let syncId = loginDetails["syncid"] as? String {
            self.syncId = syncId
        } else {
            self.syncId = ""
        }
        if let userId = loginDetails["userid"] as? String {
            self.userId = userId
        } else {
            self.userId = ""
        }
       
    }
}
