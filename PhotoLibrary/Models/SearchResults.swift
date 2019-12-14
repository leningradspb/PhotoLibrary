//
//  SearchResults.swift
//  PhotoLibrary
//
//  Created by Eduard Sinyakov on 22/08/2019.
//  Copyright © 2019 Eduard Sinyakov. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
    
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue : String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}


