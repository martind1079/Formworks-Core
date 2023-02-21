//
//  FormTable.swift
//  FWNavigation
//
//  Created by Martin Doyle on 18/02/2023.
//

import Foundation

class ContainerLayout{ }

class FWTableCell { }

class TableHeaders: FormElement { }

class FormTable: FormElement, FormworksCollection {
    var formElements: [FormElement] = []
    
    var layout: ContainerLayout?
    
    var children: [FormElement]
    
    func getLayoutElements() -> [FormElement] {
        return children
    }
    
    func destroyCollection() {
        
    }
    
//    func addElementsToLayout(sectionView: SectionView) {
//
//    }
    
    init(formElements: [FormElement], layout: ContainerLayout, children: [FormElement]) {
        self.formElements = formElements
        self.layout = layout
        self.children = children
        super.init(name: "", type: .text, title: "", value: nil)
    } 
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
