//
//  Favorite.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import UIKit

struct Favorite: Codable {
    let title: String
    let year: String
    let imdbId: String
    let type: String
    let poster: URL
    // optional keys
    let plot: String?
    
    // computed property to return image from documents
    var image: UIImage? {
        set{}
        get {
            let imageURL = MovieDataStore.manager.dataFilePath(withPathName: imdbId)
            let docImage = UIImage(contentsOfFile: imageURL.path)
            return docImage
        }
    }
}

