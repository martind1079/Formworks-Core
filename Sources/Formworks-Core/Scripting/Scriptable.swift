//
//  Scriptable.swift
//  FlowNavigator
//
//  Created by Martin Doyle on 10/01/2023.
//

import Foundation

public protocol Scriptable {
    func runScript(scriptDetails: ScriptDetails, form: FWForm, completion: @escaping (ScriptUpdates) -> Void)
    func executeRaw (script: String)

    func destroyObject()
}

extension Scriptable {
    func isStartScript(scriptDetails: ScriptDetails) -> Bool {
        if scriptDetails.eventName == "OnStart" || scriptDetails.eventName == "OnOpen" {
            return true
        } else {
            return false
        }
    }
}

public class ScriptDetails {
    public var script: String
    public var eventName: String
    public var elementName: String

    public init(script: String, eventName: String, elementName: String) {
        self.script = script
        self.eventName = eventName
        self.elementName = elementName
    }
}

public class TestScriptManager: Scriptable {
    public var scriptUpdates: ScriptUpdates?
    public var completion: ((ScriptUpdates) -> Void)?

    public var scriptCount: Int = 0

    public func runScript(
        scriptDetails: ScriptDetails,
        form: FWForm,
        completion: @escaping (ScriptUpdates) -> Void) {
            self.completion = completion

      /*  let scriptUpdates = ScriptUpdates()

        let section = (form.firstPage.children as! [FormSection])[1]
        scriptUpdates.addSectionToHide(section:  section)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.completion?(scriptUpdates)
        } */
    }

    public func executeRaw(script: String) {

    }

    public func destroyObject() {

    }
}
