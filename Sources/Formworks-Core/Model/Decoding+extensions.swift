//
//  Decoding+extensions.swift
//  Waas
//
//  Created by Martin Doyle on 04/01/2023.
//

import Foundation

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if try decodeNil(forKey: key) {
                dictionary[key.stringValue] = true
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

class Generic: Decodable {
    enum MyStructKeys: String, CodingKey {
        case id
        case children
    }

    let id: Int
    var children: [FormElement]

    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: MyStructKeys.self)
            var id: Int; do {
                id = try container.decode(Int.self, forKey: .id)
            } catch {
                id = 0
            }
            self.id = id
            self.children = [FormElement]()
        }
    }
}

extension KeyedDecodingContainer {
    func decodeProperty<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T: Decodable {
        do {
            let property = try decode(T.self, forKey: key)
            return property
        } catch {
            return nil
        }
    }
}

extension UnkeyedDecodingContainer {
    mutating func decodeElement() -> [String: FormElement]? {
        decodePage()
    }

    mutating func decodePage() -> [String: FormElement]? {
        if let result = try? decode([String: FormPage].self) {
            return result
        } else {
            return decodeSection()
        }
    }

    mutating func decodeSection() -> [String: FormElement]? {
        if let result = try? decode([String: FormSection].self) {
            return result
        } else {
            return decodeGroup()
        }
    }

    mutating func decodeGroup() -> [String: FormElement]? {
        if let result = try? decode([String: FormGroup].self) {
            return result
        } else {
            return decodeText()
        }
    }

    mutating func decodeText() -> [String: FormElement]? {
        if let result = try? decode([String: FormTextField].self) {
            return result
        } else {
            return decodeSingleSelection()
        }
    }

    mutating func decodeSingleSelection() -> [String: FormElement]? {
        if let result = try? decode([String: SingleSelect].self) {
            return result
        } else {
            return decodeDate()
        }
    }

    mutating func decodeDate() -> [String: FormElement]? {
        if let result = try? decode([String: FormDate].self) {
            return result
        } else {
            return decodeParagraphText()
        }
    }

    mutating func decodeParagraphText() -> [String: FormElement]? {
        if let result = try? decode([String: Paragraph].self) {
            return result
        } else {
            return decodeTime()
        }
    }

    mutating func decodeTime() -> [String: FormElement]? {
        if let result = try? decode([String: Time].self) {
            return result
        } else {
            return decodeCheckbox()
        }
    }

    mutating func decodeCheckbox() -> [String: FormElement]? {
        if let result = try? decode([String: Checkbox].self) {
            return result
        } else {
            return decodeMultiSelect()
        }
    }

    mutating func decodeMultiSelect() -> [String: FormElement]? {
        if let result = try? decode([String: MultiSelect].self) {
            return result
        } else {
            return decodeSignature()
        }
    }

    mutating func decodeSignature() -> [String: FormElement]? {
        if let result = try? decode([String: Signature].self) {
            return result
        } else {
            return decodeLabel()
        }
    }

    mutating func decodeLabel() -> [String: FormElement]? {
        if let result = try? decode([String: FormLabel].self) {
            return result
        } else {
            return nil
        }
    }

    mutating func decodeFormElementChildren(parent: FormElement) -> [FormElement] {
        var elements = [FormElement]()

        while !self.isAtEnd {
            do {
                if let decodedElement = decodeElement() {
                    for key in decodedElement.keys {
                        guard let child = decodedElement[key] else {
                            continue
                        }
                        child.parent = parent
                        elements.append(child)
                    }
                } else {
                    _ = try? decode([String: Generic].self)
                    print("unable to decode at index: \(currentIndex)")
                }
            }
        }
        return elements
    }
}
