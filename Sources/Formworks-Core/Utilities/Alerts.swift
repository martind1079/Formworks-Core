//
//  Alerts.swift
//  WFaaS
//
//  Created by Martin Doyle on 30/01/2023.
//

import Foundation
import SwiftUI

public struct AlertItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let buttonItems: [ButtonItem]
    
    public init(title: String, message: String, buttonItems: [ButtonItem]) {
        self.title = title
        self.message = message
        self.buttonItems = buttonItems
    }
}

public struct ButtonItem: Identifiable {
    
    public let id = UUID()
    
    public var title: String
    public var action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}
