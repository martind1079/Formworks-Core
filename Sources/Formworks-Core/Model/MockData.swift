//
//  MockData.swift
//  Waas
//
//  Created by Martin Doyle on 19/12/2022.
//

import Foundation

enum MockData {
    static let projects = [
        Project(title: "Project 1", modules: modules),
        Project(title: "Project 2", modules: modules)
    ]

    static let forms = [
        FormData(
            permitNumber: "123454",
            creationDate: Date(), supervisor: "Martin",
            creator: "John", currentStep: .submission),
        FormData(
            permitNumber: "345345",
            creationDate: Date(), supervisor: "Martin",
            creator: "John", currentStep: .submission),
        FormData(
            permitNumber: "568568",
            creationDate: Date(), supervisor: "Martin",
            creator: "John", currentStep: .submission)
    ]

    static let modules = [
        Module(title: "Hot Works", templates: templates)
    ]
    static let templates = [
        Template(title: "Hot Works Permit V1", forms: forms)
    ]

    static var testForm: FWForm? {
        guard let testFormPath = Bundle.main.path(forResource: "Permit", ofType: "json") else {
            return nil
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: testFormPath)) else {
            return nil
        }

        guard let JSON = try? JSONDecoder().decode([String: FWForm].self, from: data), let form = JSON["Form"] else {
            return nil
        }

        return form
    }
}
