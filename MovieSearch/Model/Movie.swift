//
//  Movie.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let artworkUrl100: URL
    let artworkUrl60: URL
    let collectionName: String?
    let collectionId: Int?
    let trackId: Int
    let longDescription: String?
}

struct MovieResults: Codable {
    let results: [Movie]
}
