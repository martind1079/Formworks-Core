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
    let title: String
    let message: String
    let buttonItems: [ButtonItem]
}

public struct ButtonItem: Identifiable {
    
    public let id = UUID()
    
    var title: String
    var action: () -> Void
}
