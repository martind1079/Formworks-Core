//
//  Scriptable.swift
//  FlowNavigator
//
//  Created by Martin Doyle on 10/01/2023.
//

import Foundation

protocol Scriptable {
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

class ScriptDetails {
    var script: String
    var eventName: String
    var elementName: String

    init(script: String, eventName: String, elementName: String) {
        self.script = script
        self.eventName = eventName
        self.elementName = elementName
    }
}

class TestScriptManager: Scriptable {
    var scriptUpdates: ScriptUpdates?
    var completion: ((ScriptUpdates) -> Void)?

    var scriptCount: Int = 0

    func runScript(
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

    func executeRaw(script: String) {

    }

    func destroyObject() {

    }
}
