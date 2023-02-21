//
//  FormElements.swift
//  Waas
//
//  Created by Martin Doyle on 04/01/2023.
//

import Foundation

public enum FormElementType: String {
    case text = "Text"
    case signature = "Signature"
    case time = "Time"
    case date = "Date"
    case multiSelect = "MultiSelection"
    case singleSelect = "SingleSelection"
    case checkbox = "Checkbox"
    case group = "Group"
    case section = "Section"
    case paragraph = "ParagraphText"
    case form = "Form"
    case page = "Page"
    case label = "Label"
}

public class SectionHeader: FormElement {
    var titleHeight : CGFloat = 0
}

public class FormSection: FormElement, FormworksCollection {
    
    var children: [FormElement] = []
    
    var formElements: [FormElement] = []
    
    var layout: ContainerLayout?
    
    func getLayoutElements() -> [FormElement] {
        []
    }
    
    func destroyCollection() {
        
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.section, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
        }
        self.type = .section
    }
}

public class FWForm: FormElement, FormworksCollection {
    
    var formElements: [FormElement] = []
    var layout: ContainerLayout?
    var children: [FormElement] = []
    var currentFocussedElement: FormElement?
    var currentResponderElement: FormElement?
    
    func getLayoutElements() -> [FormElement] {
        children
    }
    
    func destroyCollection() {
        
    }

    
    var scriptManager: Scriptable?
    var audioClips: [String: Any]?

    var firstPage: FormPage? {
        self.children.first as? FormPage
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        audioClips = try? container.decode([String: Any].self, forKey: .audioClips)

        do {
            try super.init(from: decoder)
            self.type = .form
            self.scriptManager = TestScriptManager()
        }
    }
    
    func validate(completion: @escaping (Bool) -> Void) {
        // run validation scripts here
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(self.valid)
        }
    }
    func hasPreviousTabbingElement(validating: Bool) -> Bool {
        false
    }
    
    func hasNextTabbingElement(validating: Bool) -> Bool {
        true
    }
}

public class FormPage: FormElement, FormworksCollection {
    var formElements: [FormElement] = []
    
    var layout: ContainerLayout?
    
    var children: [FormElement] = []
    
    func getLayoutElements() -> [FormElement] {
        children
    }
    
    func destroyCollection() {
        
    }

    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.page, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .page
        } catch {
            throw NSError()
        }
    }
    
    func getSections() -> [FormSection] {
        var result = [FormSection]()
        for child in self.children {
            if let section = child as? FormSection {
                result.append(section)
            }
        }
        return result
    }
}

public class FormGroup: FormElement {
    
    var model : [FormElement]?
    var titleHeight: CGFloat?
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.group, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .group
        } catch {
            throw NSError()
        }
    }
}

public class FormLabel: FormElement {
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.label, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .label
        } catch {
            throw NSError()
        }
    }
}

public class Paragraph: FormElement {
    var numberOfLines = 5
    var textType: TextFieldType = .paragraph

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            guard fieldIs(.paragraph, container: container) else {
                throw NSError()
            }
            self.numberOfLines = try container.decode(Int.self, forKey: .textLines)
            try super.init(from: decoder)
            self.type = .paragraph
        } catch {
            throw NSError()
        }
    }
}

public class SingleSelect: FormElement, SelectableElement {
    var options: [[String: String]]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            guard fieldIs(.singleSelect, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.options = decodeOptionsFrom(container)
            self.type = .singleSelect
        } catch {
            throw NSError()
        }
    }
}

public class MultiSelect: FormElement, SelectableElement {
    var options: [[String: String]]?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            guard fieldIs(.multiSelect, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.options = decodeOptionsFrom(container)
            self.type = .multiSelect
        } catch {
            throw NSError()
        }
    }
}

func fieldIs(_ type: FormElementType, container: KeyedDecodingContainer<FormElement.CodingKeys>) -> Bool {
    do {
        let fieldType = try container.decode(String.self, forKey: .fieldType)
        return type.rawValue == fieldType
    } catch {
        return false
    }
}

protocol SelectableElement {
    func decodeOptionsFrom(_ container: KeyedDecodingContainer<FormElement.CodingKeys>) -> [[String: String]]?
}

extension SelectableElement {
    func decodeOptionsFrom(_ container: KeyedDecodingContainer<FormElement.CodingKeys>) -> [[String: String]]? {
        do {
            var fullOptionsContainer = try container.nestedUnkeyedContainer(forKey: .options)
            var fullOptions = [[String: Any]]()
            while !fullOptionsContainer.isAtEnd {
                let result = try fullOptionsContainer.decode([String: Any].self)
                fullOptions.append(result)
            }
            var ammendedOptions = [[String: String]]()
            for option in fullOptions {
                var ammendedOption = [String: String]()
                ammendedOption["Content"] = option["Content"] as? String
                ammendedOption["Value"] = option["Value"] as? String
                ammendedOptions.append(ammendedOption)
            }
            return ammendedOptions
        } catch {
            return nil
        }
    }
}

class Signature: FormElement {
    override init(name: String, type: FormElementType, title: String, value: Any?) {
        super.init(name: name, type: type, title: title, value: value)
    }

    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.signature, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .signature
        } catch {
            throw NSError()
        }
    }
}

class Checkbox: FormElement {
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.checkbox, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .checkbox
        } catch {
            throw NSError()
        }
    }
}

class FormDate: FormElement {
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.date, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .date
        } catch {
            throw NSError()
        }
    }
}

class Time: FormElement {
    var textType: TextFieldType = .time

    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard fieldIs(.time, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            self.type = .time
        } catch {
            throw NSError()
        }
    }

    init(name: String, type: FormElementType, title: String, value: Any?, textType: TextFieldType) {
        self.textType = textType
        super.init(name: name, type: type, title: title, value: value)
    }
}

public enum TextFieldType {
    case text
    case number
    case email
    case phone
    case time
    case paragraph
}

public class FormTextField: FormElement {
    
    public var textType: TextFieldType {
        switch dataType {
        case .email:
            return .email
        case.number:
            return .number
        case .phone:
            return .number
        default:
            return .text
        }
    }

    public var dataType: DataType = .text
    public var decimalPlaces: NSNumber?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            guard fieldIs(.text, container: container) else {
                throw NSError()
            }
            try super.init(from: decoder)
            let type = try container.decode(String.self, forKey: .dataType)
            dataType = .init(caseName: type) ?? .text
            self.type = .text
        } catch {
            throw NSError()
        }
    }
}

extension FormTextField {
    public enum DataType: String, CaseIterable {
        case text = "Text"
        case email = "Email"
        case number = "Number"
        case phone = "Phone"
        case barcode = "Barcode"
        
        init?(caseName: String) {
            for value in DataType.allCases where "\(value)" == caseName {
                self = value
                return
            }
            return nil
        }
        
        public func formattedValue(newString: String, input: String, decimalPlaces: NSNumber?) -> String {
            switch self {
            case .text:
                return newString
            case .number:
                return newString.asFormattedDecimalNumber(decimalPlaces: decimalPlaces)
            case .phone:
                return newString
            case .email:
                if input.count > 1 { return input }
                return newString
            default:
                return newString
            }
        }
        
        public func characterInputIsValid(newString: String, range: NSRange, input: String) -> Bool {
            switch self {
            case .text:
                return true
            case .number:
                let charset = CharacterSet(charactersIn: "0123456789.-*()+/e")
                let setToRemove = CharacterSet(charactersIn: "-0123456789.e")
                
                if input.rangeOfCharacter(from: charset) != nil || input == "" {
                    let setToRemove = CharacterSet(charactersIn: "-0123456789.e")
                    if input.components(separatedBy: setToRemove).joined(separator: "").count > 0 {
                        return false
                    }
                    if input == " " {
                        return false
                    } else {
                        //look for more than 2 decimal places
                        var arrayOfString = newString.components(separatedBy: ".")
                        if arrayOfString.count > 2 {
                            return false
                        }
                        
                        //look for more than 2 e characters
                        arrayOfString = newString.components(separatedBy: "e")
                        if arrayOfString.count > 2 {
                            return false
                        }
                        
                        arrayOfString = newString.components(separatedBy: "-")
                        if arrayOfString.count > 2 {
                            return false
                        }
                        if arrayOfString.count > 1 {
                            if newString.hasPrefix("-") == false {
                                return false
                            }
                        }
                        
                    }
                    return true
                }
                
                return false
            case .phone:
                let setToRemove = CharacterSet(charactersIn: "0123456789-()+. ")
                if input.components(separatedBy: setToRemove).joined(separator: "").count > 0 {
                    return false
                }
                return true
            case .email:
                return true
            default:
                return true
            }
        }
    }
}

extension FormElement: Decodable {
    enum CodingKeys: String, CodingKey {
        // generic keys
        case id
        case title
        case reclaimSpaceIfHidden
        case readOnly
        case hidden
        case width
        case children
        case required
        case fontSize
        case fieldType
        case description
        case scripts
        case jsScripts
        case marginLeft
        case marginTop
        case marginRight
        case marginBottom
        case elementName
        case name
        case alias
        case dataName
        case contentWidth
        case contentHeight
        case maxImageSize
        case assignSpaceForTitle

        // form keys
        case dataTitle
        case tables
        case referenceFontSize
        case formAccessAfterSubmission
        case onlyPrefilled
        case preservePrefilled
        case thumbnail
        case audioClips
        case allowedSendActions
        case preferredScriptingLanguage

        // table keys
        case columns
        case cells
        case cellPadding
        case hasRowHeaders
        case showBorders
        case rowMetaData
        case columnMetaData
        case columnHeadersHidden

        // single / multi select keys
        case options
        case style
        case spacingHorizontal
        case spacingVertical

        // section / group / label colouring
        case color
        case textColor

        // image keys
        case blobInfo
        case imageData

        // paragraph keys
        case textLines

        // textField Keys
        case dataType
        case decimalPlaces
        case PDFAsBarcode
        case isUpperCase

        // label Keys
        case isHTML

        // help Keys
        case value

        // date keys
        case format
    }
}

extension Array where Element == FormElement {
    func formDisplayable() -> [FormElement] {
        filter {
            switch $0.type {
            case .text:
                return $0.title.isEmpty == false
            case .signature, .multiSelect, .singleSelect, .label, .checkbox, .date, .time, .paragraph:
                return true
            default:
                return false
            }
        }
    }
    
    func required() -> [FormElement] {
        filter { $0.valid == false }
    }
}

//extension Array where Element == FormSection {
//    func required() -> [FormSection] {
//        filter {
//            var required = false
//
//            if let children = $0.children {
//                required = children.required().isEmpty == false
//            }
//
//            return required
//        }
//    }
//}
