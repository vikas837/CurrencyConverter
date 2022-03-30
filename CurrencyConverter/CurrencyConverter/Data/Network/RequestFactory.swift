//
//  RequestFactory.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 26/03/22.
//

import Foundation

enum RequestMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

final class RequestFactory {
    
    
    
    static func request(method: RequestMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
