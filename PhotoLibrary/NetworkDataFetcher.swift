//
//  NetworkDataFetcher.swift
//  PhotoLibrary
//
//  Created by Eduard Sinyakov on 22/08/2019.
//  Copyright © 2019 Eduard Sinyakov. All rights reserved.
//

import Foundation

class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
        
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else {return nil}
        do {
          let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON \(jsonError)")
            return nil
        }
    } // endOfFunction
}
