//
//  Models.swift
//  GAMES!
//
//  Created by Piernick, Dave on 6/12/19.
//  Copyright © 2019 Piernick, Dave. All rights reserved.
//

import Foundation
import UIKit

struct SearchResponse: Codable {
    var results: [Game]
}

struct Game: Codable {
    var name: String?
    var imageDict: Image?
    var description: String?
    var image: UIImage?

    enum CodingKeys: String, CodingKey {
        case name
        case imageDict = "image"
        case description
    }
}

struct Image: Codable {
    var originalURL: String?

    enum CodingKeys: String, CodingKey {
        case originalURL = "original_url"
    }
}
