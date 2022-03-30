//
//  RequestService.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 26/03/22.
//

import Foundation

final class RequestService {
    
    func loadData(urlString: String, session: URLSession = URLSession(configuration: .default), method: RequestMethod, completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.network))
            return nil
        }
        
        var request = RequestFactory.request(method: method, url: url)
        
        if let reachability = Reachability(), !reachability.isReachable {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.network))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}
