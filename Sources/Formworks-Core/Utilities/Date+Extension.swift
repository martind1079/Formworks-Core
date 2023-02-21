//
//  Date+Extension.swift
//  FWNavigation
//
//  Created by Martin Doyle on 18/02/2023.
//

import Foundation

public extension Date {
    static let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    public var short: String {
        Self.shortDateFormatter.string(from: self)
    }
}
