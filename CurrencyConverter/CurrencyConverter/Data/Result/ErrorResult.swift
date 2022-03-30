//
//  ErrorResult.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 25/03/22.
//

import Foundation

enum ErrorResult: Error {
    case network
    case parser
    case custom
}
