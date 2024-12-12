//
//  Video.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 24.11.2024.
//

import Foundation

struct Videos: Codable {
    var results: [Video]
    
}

struct Video: Codable {
    var key: String?
    var site: String?
    var type: String?
}
