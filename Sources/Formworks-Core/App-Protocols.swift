//
//  File.swift
//  
//
//  Created by Martin Doyle on 21/02/2023.
//

import Combine
import Foundation

struct MenuSection: Identifiable {
    let id = UUID()
    
    let title: String
    let items: [MenuSectionItem]
}

struct MenuSectionItem: Identifiable {
    let id = UUID()
    let title: String
}

struct Menu {
    let sections: [MenuSection]
    
    static func testMenu() -> Menu {
        let templatesItem = MenuSectionItem(title: "Templates")
        let templatesSection = MenuSection(title: "Templates", items: [templatesItem])
        let inProgressItem = MenuSectionItem(title: "In Progress")
        let notStarted = MenuSectionItem(title: "Not Started")
        let myWorkSection = MenuSection(title: "My Work", items: [inProgressItem, notStarted])
        return Menu(sections: [templatesSection, myWorkSection])
    }
}

class MenuService: ObservableObject {
    @Published var menu: Menu
    
    init(menu: Menu) {
        self.menu = menu
    }
}

protocol MenuSelector {
    func didSelectItem(_ item: MenuSectionItem)
}

protocol FormReceiver {
    func didSelectForm(_ form: FWForm)
}

protocol LoginReceiver {
    func didLogin(with user: User)
}

protocol FormDataLoader {
    func observeFormData() -> AnyPublisher<[FormData], Never>
    func loadForms()
}

class FWDatabase: FormDataLoader {
    @Published var currentForms = [FormData]()
    func observeFormData() -> AnyPublisher<[FormData], Never> {
        $currentForms.eraseToAnyPublisher()
    }
    func loadForms() {
        currentForms = MockData.forms
    }
}

class FormRepository {
    let dataLoader: FormDataLoader
    init(dataLoader: FormDataLoader) {
        self.dataLoader = dataLoader
    }
    
    func observeForms() -> AnyPublisher<[FormData], Never> {
        dataLoader.observeFormData()
    }
    
    func load() {
        dataLoader.loadForms()
    }
    
    
}

class Session {
    let user: User
    var formManager: FormManager?
    
    func setManager(_ manager: FormManager) {
        self.formManager = manager
    }
    
    init(user: User) {
        self.user = user
    }
}

class User { }
