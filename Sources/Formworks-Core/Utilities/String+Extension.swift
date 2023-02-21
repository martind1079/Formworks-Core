//
//  File.swift
//  
//
//  Created by Martin Doyle on 21/02/2023.
//

import Foundation

public extension String {
    func asFormattedDecimalNumber(decimalPlaces: NSNumber?) -> String {
        guard self.isEmpty == false else { return self }
        var dp: NSNumber = 0
        if let decimalPlaces = decimalPlaces {
            dp = decimalPlaces
        } else {
            let components = self.components(separatedBy: ".")
            if components.count > 1 {
                let count = components[1]
                dp = NSNumber(integerLiteral: count.count)
            }
        }
        var result = self
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.maximumFractionDigits = dp.intValue
        numberFormatter.minimumFractionDigits = dp.intValue
        numberFormatter.roundingMode = .halfUp
        numberFormatter.groupingSeparator = ""
        numberFormatter.decimalSeparator = "."
        if self.contains(",") {
            numberFormatter.groupingSeparator = ","
            result = self.replacingOccurrences(of: ",", with: "")
        }
        let numberRepresentation = NSNumber(value: (result as NSString).doubleValue)
        return numberFormatter.string(from: numberRepresentation) ?? ""
    }
    
    func asFormattedTime() -> String? {
    
        var newText : String = ""
        var newValue : String
        newValue = self.replacingOccurrences(of: " ", with: "", options: [], range: nil)
        newValue = newValue.trimmingCharacters(in: CharacterSet.init(charactersIn: "!@£$%^&*()\\/':;<>.,`~=-_§± "))

        let segments = newValue.components(separatedBy: CharacterSet.init(charactersIn: "!@£$%^&*()\\/':;<>.,`~=-_§± "))
        var segment1text = ""
        var segment2text = ""
        
        if segments.count == 2 {
        
        /* correct segment count, re-format to ensure */
            let string1 = segments[0]
            let Int1 = Int(string1)
            let string2 = segments[1]
            let Int2 = Int(string2)
            
            if (Int1! > 23) {
                return nil
            }
            
            if (Int2! > 59) {
               return nil
            }
            segment1text = string1
            segment2text = string2

        } else if segments.count == 1 {
            
            /* check the length */
            
            if newValue.count == 4 {
            
                let string1 = (newValue as NSString).substring(to: 2)
                let Int1 = Int(string1)
                newValue = (newValue as NSString).substring(from: 2)
                let string2 = (newValue as NSString).substring(to: 2)
                let Int2 = Int(string2)
                
                if (Int1! > 23) {
                    return nil
                }
                
                if (Int2! > 59) {
                   return nil
                }
                segment1text = string1
                segment2text = string2

            } else if newValue.count == 2 {
            
                let s1 = Int(newValue)
                
                if (s1! > 23) {
                    return nil
                }
                segment1text = "\(s1!)"
                segment2text = "00"

            }
        }
        if segment1text.count == 1 {
            segment1text = "0\(segment1text)"
        }
        if segment2text.count == 1  {
            segment2text += "0"
        }
        if segment1text == "" || segment2text == "" {
            return nil
        } else {
            newText = "\(segment1text):\(segment2text)"
        }
        
        return newText
    }
}
