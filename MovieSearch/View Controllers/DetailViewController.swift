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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(movie: movie, favorite: favorite)
    }
    
    func configureView(movie: Movie?, favorite: Favorite?) {
        imageView.image = image
        if let movie = movie {
            movieTitleLabel.text = movie.collectionName ?? "No Title"
            movieDescription.text = movie.longDescription ?? "No Description"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-unfilled-32"), style: .plain, target: self, action: #selector(addFavorite(_:)))
        }else if let favorite = favorite {
            movieTitleLabel.text = favorite.collectionName ?? "No Title"
            movieDescription.text = favorite.longDescription ?? "No Description"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled-32"), style: .plain, target: self, action: #selector(removeFavorite))
        }
    }

    @IBAction func addFavorite(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        let success = PersistentStoreManager.manager.addToFavorites(movie: movie, andImage: image)
        if success {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled-32"), style: .plain, target: self, action: nil)
        }
    }
    
    @objc func removeFavorite() {
        let index = PersistentStoreManager.manager.getFavorites().index{$0.trackId == favorite.trackId}
        if let index = index {
            guard let favorite = favorite else { return }
            let success = PersistentStoreManager.manager.removeFavorite(fromIndex: index, andMovieImage: favorite)
            if success {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-unfilled-32"), style: .plain, target: self, action: nil)
            }
        }
    }
    

}
