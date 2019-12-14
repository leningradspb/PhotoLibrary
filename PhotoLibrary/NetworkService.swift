//
//  NetworkService.swift
//  PhotoLibrary
//
//  Created by Eduard Sinyakov on 21/08/2019.
//  Copyright © 2019 Eduard Sinyakov. All rights reserved.
//

import Foundation

class NetworkService {
    
    // построение запроса данных через URL
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let parameters = self.prepareParametrs(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        
        var requset = URLRequest(url: url)
        requset.allHTTPHeaderFields = prepareHeaders()
        requset.httpMethod = "get"
        
        let task = createDataTask(from: requset, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID 069f4109552b4b50349e7755b85003419ad2cfce294a67c2294c8e31884eb136"
        
        return headers
    }
    
    private func prepareParametrs(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"]     = searchTerm
        parameters["page"]      = String(1)
        parameters["per_page"]  = String(30)
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        
        var components = URLComponents()
        components.scheme       = "https"
        components.host         = "api.unsplash.com"
        components.path         = "/search/photos"
        components.queryItems   = params.map {URLQueryItem.init(name: $0, value: $1)}
        
        
        return components.url!
        
    }
    
    private func createDataTask(from requset: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: requset, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                 completion(data, error)
            }
        })
    }
}
