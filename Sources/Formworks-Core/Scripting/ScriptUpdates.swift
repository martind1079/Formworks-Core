//
//  ScriptUpdates.swift
//  FlowNavigator
//
//  Created by Martin Doyle on 10/01/2023.
//

import Foundation

@objc public enum ScriptUpdateType: Int {
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

@objc public class ScriptUpdates: NSObject {
    public var elementToFocus: FormElement?
    public var pageToChangeTo: FormPage?
    public var updatePage: FormPage?
    public var elements = Set<FormElement>()
    public var hidePages = Set<FormPage>()
    public var showPages = Set<FormPage>()
    public var hideSections = Set<FormSection>()
    public var showSections = Set<FormSection>()
    public var updateSections = Set<FormSection>()

    public func addPageToHide(page: FormPage) {
        if showPages.contains(page) {
            showPages.remove(page)
        }
        hidePages.update(with: page)
    }

    public func addPageToShow(page: FormPage) {
        if hidePages.contains(page) {
            hidePages.remove(page)
        }
        showPages.update(with: page)
    }

    public func addPageToChangeTo(page: FormPage) {
        pageToChangeTo = page
    }

    public func updatePage(page: FormPage) {
        updatePage = page
    }

    public func addSectionToHide(section: FormSection) {
        if showSections.contains(section) {
            showSections.remove(section)
        }
        hideSections.update(with: section)
    }

    public func addSectionToShow(section: FormSection) {
        if hideSections.contains(section) {
            hideSections.remove(section)
        }
        showSections.update(with: section)
    }

    public func addSectionToUpdate(section: FormSection) {
        updateSections.update(with: section)
    }

    public func addElementToUpdate(element: FormElement) {
        elements.update(with: element)
    }
}
