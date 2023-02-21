//
//  ProjectModels.swift
//  Waas
//
//  Created by Martin Doyle on 04/01/2023.
//

import Foundation

public struct Project: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let modules: [Module]
}

public struct Module: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let templates: [Template]
}

public struct Template: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let forms: [FormData]
}

extension FormData.Step {
    var stringValue: String {
        switch self {
        case .review: return "Review"
        case .sign: return "Sign"
        case .submission: return "Submission"
        }
    }
}

public struct FormData: Identifiable, Hashable {
    public let id = UUID()

    enum Step {
        case submission
        case review
        case sign
    }

    public var permitNumber: String
    public let creationDate: Date
    public let supervisor: String
    public let creator: String
    let currentStep: Step

    public static func new() -> FormData {
        FormData(permitNumber: "12345", creationDate: Date(), supervisor: "Martin", creator: "John", currentStep: .submission)
    }
}

public struct WFActionItem: Identifiable {
    public let id = UUID()
    var title: String
    var action: (() -> Void)?
}
