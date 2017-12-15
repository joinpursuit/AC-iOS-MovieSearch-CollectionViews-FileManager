//
//  Favorite.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import UIKit

struct Favorite: Codable {
    let collectionName: String?
    let collectionId: Int?
    let trackId: Int
    let longDescription: String?
    let artworkUrl100: URL
    let artworkUrl60: URL
    
    // computed property to return image from documents
    var image: UIImage? {
        set{}
        get {
            let imageURL = PersistentStoreManager.manager.dataFilePath(withPathName: "\(trackId)")
            let docImage = UIImage(contentsOfFile: imageURL.path)
            return docImage
        }
    }
}
