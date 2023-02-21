//
//  DateHelper.swift
//  FWNavigation
//
//  Created by Martin Doyle on 20/02/2023.
//

import Foundation

func localisedDateFormat() -> String {
    var defaultFormat = "dd/MM/yyyy"

    /* USA */
    if Locale.current.identifier == "en_US" {
        defaultFormat = "MM/dd/yyyy"
    }

    /* CANADA */
    if Locale.current.identifier == "en_CA" {
        defaultFormat = "MM/dd/yyyy"
    }

    return defaultFormat
}
