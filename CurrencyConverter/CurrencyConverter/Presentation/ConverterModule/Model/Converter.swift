//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 26/03/22.
//

import Foundation

struct Converter {
    let base : String
    let date: String
    let amount:Double
    let rates: [CurrencyRate]
}

extension Converter : Parceable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<Converter, ErrorResult> {
        if let base = dictionary["base"] as? String,
            let date = dictionary["date"] as? String,
            let amount = dictionary["amount"] as? Double,
            let rates = dictionary["rates"] as? [String: Double] {
            
            let finalRates : [CurrencyRate] = rates.compactMap({ CurrencyRate(currencyIso: $0.key, rate: $0.value) })
            let conversion = Converter(base: base, date: date, amount:amount, rates: finalRates)
            
            return Result.success(conversion)
        } else {
            return Result.failure(ErrorResult.parser)
        }
    }
}
