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

    var permitNumber: String
    let creationDate: Date
    let supervisor: String
    let creator: String
    let currentStep: Step

    static func new() -> FormData {
        FormData(permitNumber: "12345", creationDate: Date(), supervisor: "Martin", creator: "John", currentStep: .submission)
    }
}

struct WFActionItem: Identifiable {
    let id = UUID()
    var title: String
    var action: (() -> Void)?
}
