//
//  ConverterModel.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 26/03/22.
//

import Foundation
import UIKit

struct ConverterModel {
    var baseCountryDescription:Country?
    var toCountryDescription:Country?
}

struct Country {
    var title: String?
    var code:String?
    var currency: String?
    var flag: UIImage?
    var amount:Double?
    var range:CountryRange?
}

