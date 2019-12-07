//
//  Recipe.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct Recipes: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case images
        case lastUpdated
        case description
        case instructions
        case difficulty
    }
    
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
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.uuid = try container.decode(String.self, forKey: .uuid)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.images = try container.decode([String].self, forKey: .images)
//        self.lastUpdated = try container.decode(Int.self, forKey: .lastUpdated)
//        self.description = try container.decodeIfPresent(String.self, forKey: .description)
//        self.instructions = try container.decode(String.self, forKey: .instructions)
//        self.difficulty = try container.decode(Int.self, forKey: .difficulty)
//    }
}
