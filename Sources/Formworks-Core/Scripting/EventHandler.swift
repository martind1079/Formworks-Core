//
//  EventHandler.swift
//  FlowNavigator
//
//  Created by Martin Doyle on 10/01/2023.
//

import Foundation

protocol EventHandler {
    func runScript(forEvent event: String)
}

extension EventHandler {
    func onEnabled() {
        runScript(forEvent: "onEnabled")
    }

    func onDisabled() {
        runScript(forEvent: "onDisabled")
    }

    func onShow() {
        runScript(forEvent: "onShow")
    }

    func onHide() {
        runScript(forEvent: "onHide")
    }

    func onFocus() {
        runScript(forEvent: "onFocus")
    }

    func onBlur() {
        runScript(forEvent: "onBlur")
    }

    func onValidate() {
        runScript(forEvent: "onValidate")
    }

    func onValueChange() {
        runScript(forEvent: "onValueChange")
    }
}
