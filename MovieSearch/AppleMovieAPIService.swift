//
//  AppleMovieAPIService.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import Foundation

let searchURL = "https://itunes.apple.com/search?media=movie&limit=200&term="
let session = URLSession.shared

class AppleMovieAPIService {

    static func searchMovie(keyword: String, completion: @escaping (Error?, [Movie]?) -> Void) {
        session.dataTask(with: URL(string: "\(searchURL)\(keyword)")!, completionHandler: { (data, response, error) in
            if let error = error {
                completion(error, nil)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let rawResults = try decoder.decode(MovieResults.self, from: data)
                    completion(nil, rawResults.results)
                } catch {
                    print("decoding error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
}
