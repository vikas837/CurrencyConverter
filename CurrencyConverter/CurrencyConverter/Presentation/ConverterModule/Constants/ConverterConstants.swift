//
//  Constants.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 27/03/22.
//

import Foundation


struct CurencyConverterAPIs {
    static let BASE_URL = "https://api.frankfurter.app/latest"
}

struct DefaultSelections {
    static let BaseCountryName = "United Kingdom"
    static let BaseCountryCode = "GB"
    static let ToCountryName = "India"
    static let ToCountryCode = "IN"
    static let BaseCurrencyCode = "GBP"
    static let ToCurrencyCode = "INR"
}


struct ConverterConstants {
    static let ErrorOccurred = "An error occured"
    static let Close = "Close"
    static let SameCountry = "You have selected the same countries"
}


public struct AccessibilityIdentifier {
    static let ConverterView = "AccessibilityIdentifierConverterView"
}

public struct ErrorMessages {
    static let APINotSupportedError = "API does not support selected currency"
    static let ParsingError = "Error occurr during parsing data"
    static let OtherError = "general error"
    static let SameCurrenciesError = "Both countries have same currency, please select other country"
}

struct XIBNames {
    static let ConverterView = "ConverterView"
}



