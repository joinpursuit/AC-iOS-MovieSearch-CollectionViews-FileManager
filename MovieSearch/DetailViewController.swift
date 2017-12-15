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
    var image: UIImage! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(movie: movie)
    }
    
    func configureView(movie: Movie) {
        movieTitleLabel.text = movie.collectionName ?? "No Title"
        movieDescription.text = movie.longDescription ?? "No description :-("
        imageView.image = image
    }

    @IBAction func addFavorite(_ sender: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        PersistentStoreManager.manager.addToFavorites(movie: movie, andImage: image)
    }
    

}
