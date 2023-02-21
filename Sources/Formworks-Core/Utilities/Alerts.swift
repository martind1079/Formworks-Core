//
//  Alerts.swift
//  WFaaS
//
//  Created by Martin Doyle on 30/01/2023.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let buttonItems: [ButtonItem]
}

struct ButtonItem: Identifiable {
    
    let id = UUID()
    
    var title: String
    var action: () -> Void
}
