//
//  Recipe.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    let uuid: String
    let name: String
    let images: [String]
    let lastUpdated: Int
    let description: String?
    let instructions: String
    let difficulty: Int
    
    var lastUpdatedDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(lastUpdated))
    }
}
