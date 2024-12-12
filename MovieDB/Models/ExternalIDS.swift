//
//  ExternalIDS.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 25.11.2024.
//

import Foundation

struct ExternalIDS: Codable {
    let id: Int
    let imdbID, wikidataID, facebookID, instagramID, twitterID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdb_id"
        case wikidataID = "wikidata_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case twitterID = "twitter_id"
    }
}

