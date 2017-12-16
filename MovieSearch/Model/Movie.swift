//
//  Movie.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let year: String
    let imdbId: String
    let type: String
    let poster: URL
    // optional keys
    var plot: String?
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId = "imdbID"
        case type = "Type"
        case poster = "Poster"
        case plot = "Plot"
    }
}

struct SearchResults: Codable {
    let search: [Movie]
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}



