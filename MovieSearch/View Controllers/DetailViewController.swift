//
//  DetailViewController.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var favoriteBarItem: UIBarButtonItem!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieDescription: UILabel!
    
    var movie: Movie!
    var favorite: Favorite!
    var image: UIImage!
    var currentIMDDId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = movie {
            // fetch more movie info to present since the initial api call for search on OMDb doesn't have plot info
            fetchMovieDetails()
        }
        configureView(movie: movie, favorite: favorite) 
    }
    
    // only if coming from movie search view controller
    // we need to make a next api call to get the plot info and other details that may be necessary for the ui
    func fetchMovieDetails() {
        guard let encodedString = movie.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        OMDbAPIService.titleSearch(keyword: encodedString) { (error, movie) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let movie = movie {
                // update movie views
                self.configureView(movie: movie, favorite: nil)
            }
        }
    }
    
    func configureView(movie: Movie?, favorite: Favorite?) {
        // must be on main thread to update movie info
        DispatchQueue.main.async {
            self.imageView.image = self.image
        }
        if let movie = movie {
            currentIMDDId = movie.imdbId
            DispatchQueue.main.async {
                self.movieTitleLabel.text = movie.title
                self.movieDescription.text = movie.plot ?? "No Description"
                
                // update the movie to include the extra details retrieved from the titleSearch() API call
                self.movie.plot = movie.plot
            }
            if MovieDataStore.manager.isMovieInFavorites(movie: movie) {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled-32"), style: .plain, target: self, action: #selector(removeFavorite))
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-unfilled-32"), style: .plain, target: self, action: #selector(addFavorite(_:)))
            }
        }else if let favorite = favorite {
            currentIMDDId = favorite.imdbId
            movieTitleLabel.text = favorite.title
            movieDescription.text = favorite.plot ?? "No Description"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled-32"), style: .plain, target: self, action: #selector(removeFavorite))
        }
    }

    @IBAction func addFavorite(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        let _ = MovieDataStore.manager.addToFavorites(movie: movie, andImage: image)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func removeFavorite() {
        guard let favoriteToBeRemoved = MovieDataStore.manager.getFavoriteWithId(imdbId: currentIMDDId)
            else { return }
        let index = MovieDataStore.manager.getFavorites().index{$0.imdbId == currentIMDDId}
        if let index = index {
            let _ = MovieDataStore.manager.removeFavorite(fromIndex: index, andMovieImage: favoriteToBeRemoved)
            navigationController?.popViewController(animated: true)
        }
    }
    

}
