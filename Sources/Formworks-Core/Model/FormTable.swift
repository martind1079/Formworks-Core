//
//  FormTable.swift
//  FWNavigation
//
//  Created by Martin Doyle on 18/02/2023.
//

import Foundation

public class ContainerLayout{
    public init() {
        
    }
}

public class FWTableCell {
    public init() {
        
    }
}

public class TableHeaders: FormElement { }

public class FormTable: FormElement, FormworksCollection {
    public var formElements: [FormElement] = []
    
    public var layout: ContainerLayout?
    
    public var children: [FormElement]
    
    public func getLayoutElements() -> [FormElement] {
        return children
    }
    
    public func destroyCollection() {
        
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
