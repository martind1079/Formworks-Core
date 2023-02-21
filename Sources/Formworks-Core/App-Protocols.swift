//
//  File.swift
//  
//
//  Created by Martin Doyle on 21/02/2023.
//

import Combine
import Foundation

public struct MenuSection: Identifiable {
    public let id = UUID()
    
    public let title: String
    public let items: [MenuSectionItem]
}

public struct MenuSectionItem: Identifiable {
    public let id = UUID()
    public let title: String
}

public struct Menu {
    public let sections: [MenuSection]
    
    public static func testMenu() -> Menu {
        let templatesItem = MenuSectionItem(title: "Templates")
        let templatesSection = MenuSection(title: "Templates", items: [templatesItem])
        let inProgressItem = MenuSectionItem(title: "In Progress")
        let notStarted = MenuSectionItem(title: "Not Started")
        let myWorkSection = MenuSection(title: "My Work", items: [inProgressItem, notStarted])
        return Menu(sections: [templatesSection, myWorkSection])
    }
}

public class MenuService: ObservableObject {
    @Published public var menu: Menu
    
    public init(menu: Menu) {
        self.menu = menu
    }
}

public protocol MenuSelector {
    func didSelectItem(_ item: MenuSectionItem)
}

public protocol FormReceiver {
    func didSelectForm(_ form: FWForm)
}

public protocol LoginReceiver {
    func didLogin(with user: User)
}

public protocol FormDataLoader {
    func observeFormData() -> AnyPublisher<[FormData], Never>
    func loadForms()
}

public class FWDatabase: FormDataLoader {
    @Published var currentForms = [FormData]()
    
    public init() {
        
    }
    
    public func observeFormData() -> AnyPublisher<[FormData], Never> {
        $currentForms.eraseToAnyPublisher()
    }
    public func loadForms() {
        currentForms = MockData.forms
    }
}

public class FormRepository {
    let dataLoader: FormDataLoader
    public init(dataLoader: FormDataLoader) {
        self.dataLoader = dataLoader
    }
    
    public func observeForms() -> AnyPublisher<[FormData], Never> {
        dataLoader.observeFormData()
    }
    
    public func load() {
        dataLoader.loadForms()
    }
    
    
}

public class Session {
    let user: User
    public var formManager: FormManager?
    
    public func setManager(_ manager: FormManager) {
        self.formManager = manager
    }
    
    public init(user: User) {
        self.user = user
    }
}
