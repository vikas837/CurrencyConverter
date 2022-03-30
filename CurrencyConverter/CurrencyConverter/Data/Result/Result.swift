//
//  Result.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 25/03/22.
//

import Foundation

enum Result<T, E:Error> {
    case success(T)
    case failure(E)
}
