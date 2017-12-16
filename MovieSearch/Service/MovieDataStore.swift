//
//  MovieDataStore.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import UIKit

class MovieDataStore {
    
    static let kPathname = "Favorites.plist"
    
    // singleton
    private init(){}
    static let manager = MovieDataStore()
    
    private var favorites = [Favorite]() {
        didSet{
            saveToDisk()
        }
    }
    
    // returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // /documents/Favorites.plist
    // returns the path for supplied name from the dcouments directory
    func dataFilePath(withPathName path: String) -> URL {
        return MovieDataStore.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save to documents directory
    // write to path: /Documents/
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: MovieDataStore.kPathname), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("===================================================\n")
    }
    
    // load from documents directory
    func load() {
        // what's the path we are reading from?
        let path = dataFilePath(withPathName: MovieDataStore.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    // does 2 tasks:
    // 1. stores image in documents folder
    // 2. appends favorite item to array 
    func addToFavorites(movie: Movie, andImage image: UIImage) -> Bool  {
        // checking for uniqueness
        let indexExist = favorites.index{ $0.imdbId == movie.imdbId }
        if indexExist != nil { print("FAVORITE EXIST"); return false }
        
        // 1) save image from favorite photo
        let success = storeImageToDisk(image: image, andMovie: movie)
        if !success { return false }
        
        // 2) save favorite object
        let newFavorite = Favorite.init(title: movie.title, year: movie.year, imdbId: movie.imdbId, type: movie.type, poster: movie.poster, plot: movie.plot)
        favorites.append(newFavorite)
        return true
    }
    
    // store image
    func storeImageToDisk(image: UIImage, andMovie movie: Movie) -> Bool {
        // packing data from image
        guard let imageData = UIImagePNGRepresentation(image) else { return false }
        
        // writing and saving to documents folder
        
        // 1) save image from favorite photo
        let imageURL = MovieDataStore.manager.dataFilePath(withPathName: movie.imdbId)
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        return true
    }
    
    func isMovieInFavorites(movie: Movie) -> Bool {
        // checking for uniqueness
        let indexExist = favorites.index{ $0.imdbId == movie.imdbId }
        if indexExist != nil {
            return true
        } else {
            return false
        }
    }
    
    func getFavoriteWithId(imdbId: String) -> Favorite? {
        let index = getFavorites().index{$0.imdbId == imdbId}
        guard let indexFound = index else { return nil }
        return favorites[indexFound]
    }
        
    func getFavorites() -> [Favorite] {
        return favorites
    }
    
    func removeFavorite(fromIndex index: Int, andMovieImage favorite: Favorite) -> Bool {
        favorites.remove(at: index)
        // remove image
        let imageURL = MovieDataStore.manager.dataFilePath(withPathName: favorite.imdbId)
        do {
            try FileManager.default.removeItem(at: imageURL)
            print("\n==============================================================================")
            print("\(imageURL) removed")
            print("==============================================================================\n")
            return true
        } catch {
            print("error removing: \(error.localizedDescription)")
            return false
        }
    }

}
