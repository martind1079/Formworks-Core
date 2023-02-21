//
//  ScriptUpdates.swift
//  FlowNavigator
//
//  Created by Martin Doyle on 10/01/2023.
//

import Foundation

@objc enum ScriptUpdateType: Int {
    case focus
    case elementUpdate
    case updatePage
    case hidePage
    case showPage
    case hideSection
    case showSection
    case updateSection
    case changePage
}

@objc class ScriptUpdates: NSObject {
    var elementToFocus: FormElement?
    var pageToChangeTo: FormPage?
    var updatePage: FormPage?
    var elements = Set<FormElement>()
    var hidePages = Set<FormPage>()
    var showPages = Set<FormPage>()
    var hideSections = Set<FormSection>()
    var showSections = Set<FormSection>()
    var updateSections = Set<FormSection>()

    func addPageToHide(page: FormPage) {
        if showPages.contains(page) {
            showPages.remove(page)
        }
        hidePages.update(with: page)
    }

    func addPageToShow(page: FormPage) {
        if hidePages.contains(page) {
            hidePages.remove(page)
        }
        showPages.update(with: page)
    }

    func addPageToChangeTo(page: FormPage) {
        pageToChangeTo = page
    }

    func updatePage(page: FormPage) {
        updatePage = page
    }

    func addSectionToHide(section: FormSection) {
        if showSections.contains(section) {
            showSections.remove(section)
        }
        hideSections.update(with: section)
    }

    func addSectionToShow(section: FormSection) {
        if hideSections.contains(section) {
            hideSections.remove(section)
        }
        showSections.update(with: section)
    }

    func addSectionToUpdate(section: FormSection) {
        updateSections.update(with: section)
    }

    func addElementToUpdate(element: FormElement) {
        elements.update(with: element)
    }
}
