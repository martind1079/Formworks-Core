//
//  FormElement.swift
//  FlowNavigator
//
//  Created by Martin Doyle on 10/01/2023.
//

import Foundation

public class FormElement: Identifiable {
    public let id = UUID()
    var name: String = ""
    var elementName: String = ""
    var type: FormElementType = .form
    var fontSize: CGFloat = 14
    var title: String = ""
    var elementSize: CGSize = .zero
    var elementFrame: CGRect = .zero
    var titleLabelFrame: CGRect = .zero
    var contentFrame: CGRect = .zero
    var contentWidth: CGFloat?
    var absoluteContentFrame: CGRect = .zero// relative to the page
    var relativeContentFrame: CGRect = .zero // relative to the section
    var marginLeft: CGFloat
    var marginTop: CGFloat
    var marginRight: CGFloat
    var marginBottom: CGFloat
    var width: CGFloat
    var contentHeight: CGFloat?
    var labelOffset: CGFloat?
    var isTabItem = false
    var tabItemsIndex = 0
    var animateView = false
    var isHighlighted = false
    var isCurrentFocussedElement = false
    var colorString: String?
    var textColorString: String? = "black"
    var isFocussedElement = false
    var required = false
    var dScription = "A Subheading"
    var assignSpaceForTitle = true
    
    var hasOnBlurScript: Bool {
        false
    }
    var hasOnFocusScript: Bool {
        false
    }
    
    var onUpdate: (() -> Void)?
    
    var enabled = true {
        didSet {
            enabled ? onEnabled() : onDisabled()
        }
    }
    var visible = true {
        didSet {
            visible ? onShow() : onHide()
        }
    }
    var scripts: [String: Any]?

    var value: Any? {
        didSet {
            dataClock += 1
            onValueChange()
        }
    }
    var dataClock = 0 {
        didSet {
            parent?.dataClock += 1
        }
    }
    var parentForm: FWForm? {
        if let parent = parent {
            return parent.parentForm
        }
        return (self as? FWForm)
    }

    var elementDescription = ""
    var parent: FormElement?
    var valid: Bool {
        var result = true
        if required && value == nil {
            result = false
        }
        guard let self = self as? FormworksCollection else { return result }
     
        for child in self.children where child.valid == false {
            result = false
        }
        
        return result
    }
    var message: String = ""

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decodeProperty(String.self, forKey: .title) ?? ""
        self.enabled = !(try container.decodeProperty(Bool.self, forKey: .readOnly) ?? true)
        self.visible = !(try container.decodeProperty(Bool.self, forKey: .hidden) ?? true)
        self.required = try container.decodeProperty(Bool.self, forKey: .required) ?? true
        self.name = try container.decodeProperty(String.self, forKey: .name) ?? ""
        self.elementName = try container.decodeProperty(String.self, forKey: .elementName) ?? ""
        self.elementDescription = try container.decodeProperty(String.self, forKey: .description) ?? ""
        self.scripts = try? container.decode([String: Any].self, forKey: .jsScripts)
        self.marginTop = try container.decodeProperty(CGFloat.self, forKey: .marginTop) ?? 0
        self.marginLeft = try container.decodeProperty(CGFloat.self, forKey: .marginLeft) ?? 0
        self.marginRight = try container.decodeProperty(CGFloat.self, forKey: .marginRight) ?? 0
        self.marginBottom = try container.decodeProperty(CGFloat.self, forKey: .marginBottom) ?? 0
        self.width = try container.decodeProperty(CGFloat.self, forKey: .width) ?? 0

        // test code
        self.scripts = ["onValueChange": "A Bunch Of Script To Run"]
        
        guard var self = self as? FormworksCollection else { return }

        if var childContainer = try? container.nestedUnkeyedContainer(forKey: .children) {
            self.children = childContainer.decodeFormElementChildren(parent: self as! FormElement)
        }
    }

    init(name: String, type: FormElementType, title: String, value: Any?) {
        self.name = name
        self.type = type
        self.title = title
        self.value = value
        marginTop = 0
        marginLeft = 0
        marginRight = 0
        marginBottom = 0
        width = 0
    }
}



extension FormElement: Equatable {
    public static func == (lhs: FormElement, rhs: FormElement) -> Bool {
        lhs.name == rhs.name
    }
}

extension FormElement: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension FormElement: EventHandler {
    func runScript(forEvent event: String) {
        guard let scripts = self.scripts, let script = scripts[event] as? String, let form = parentForm else {
            return
        }

        let scriptDetails = ScriptDetails(script: script, eventName: event, elementName: name)

        form.scriptManager?.runScript(scriptDetails: scriptDetails, form: form) { updates in
            //form.formRenderer?.renderForm(updates: updates)
        }
    }
}

protocol FormworksCollection  {
    
    // a collection may or may not have layoutItems yet, if we do have them, recycle the viewModels when updating a layout
    // important for avoiding asynchromous communication to removed viewModels that caused problems previously
    
    var formElements : [FormElement] { get set }
   // var layout : ContainerLayout? { get set }
    var children: [FormElement] { get set }
    func getLayoutElements() -> [FormElement]
    func destroyCollection()
   // func addElementsToLayout(sectionView : SectionView)
    func hasElement(element : FormElement) -> Bool
    
}

extension FormworksCollection {
    func hasElement(element: FormElement) -> Bool {
        guard children.isEmpty == false else { return false }
        for child in children {
            if let collection = child as? FormworksCollection, collection.hasElement(element: element) {
                return true
            } else if child.name == element.name {
                return true
            }
        }
        return false
    }
}
