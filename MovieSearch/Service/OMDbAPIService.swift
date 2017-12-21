//
//  OMDbAPIService.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/16/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import Foundation

class OMDbAPIService {
    
    static let movieSearchURL = "http://www.omdbapi.com/?apikey=76971bf5&s="
    static let titleSearchURL = "http://www.omdbapi.com/?apikey=76971bf5&t="
    static let session = URLSession.shared
    
    static func movieSearch(keyword: String, completion: @escaping (Error?, [Movie]?) -> Void) {
        session.dataTask(with: URL(string: "\(movieSearchURL)\(keyword)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    completion(nil, searchResults.search)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
    static func titleSearch(keyword: String, completion: @escaping (Error?, Movie?) -> Void) {
        session.dataTask(with: URL(string: "\(titleSearchURL)\(keyword)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(Movie.self, from: data)
                    completion(nil, movie)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
}
