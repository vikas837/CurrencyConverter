//
//  RequestHandler.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 26/03/22.
//

import Foundation

class RequestHandler {
    
    func networkResult<T: Parceable>(completion: @escaping ((Result<[T], ErrorResult>) -> Void)) ->
    ((Result<Data, ErrorResult>) -> Void) {
        
        return { dataResult in
            
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
                    print("Network error \(error)")
                    completion(.failure(.network))
                    break
                }
            })
        }
    }
    
    func networkResult<T: Parceable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) ->
    ((Result<Data, ErrorResult>) -> Void) {
        
        return { dataResult in
            
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
                    print("Network error \(error)")
                    completion(.failure(.network))
                    break
                }
            })
            
        }
    }
}
