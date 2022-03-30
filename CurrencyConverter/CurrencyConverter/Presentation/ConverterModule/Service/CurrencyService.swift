//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 26/03/22.
//

import Foundation

protocol CurrencyServiceProtocol: class {
    func fetchConverter(input:ConverterInput, completion: @escaping ((Result<Converter, ErrorResult>) -> Void))
}

class CurrencyService : RequestHandler, CurrencyServiceProtocol {
    
    static let shared = CurrencyService()
    
    var task : URLSessionTask?
    
    func fetchConverter(input:ConverterInput, completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        // cancel previous request if already in progress
        self.cancelFetchCurrencies()
                
        let endpoint = "\(CurencyConverterAPIs.BASE_URL)?&from=\(input.baseCurrency)&to=\(input.toCurrencies)"
        
        task = RequestService().loadData(urlString: endpoint, method:.GET, completion: self.networkResult(completion:completion))
    }
    
    
    func cancelFetchCurrencies(){
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
