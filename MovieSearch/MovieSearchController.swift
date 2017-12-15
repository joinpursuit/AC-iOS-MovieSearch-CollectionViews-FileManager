//
//  ViewController.swift
//  MovieSearch
//
//  Created by Alex Paul on 12/15/17.
//  Copyright © 2017 Alex Paul. All rights reserved.
//

import UIKit

class MovieSearchController: UIViewController {

    @IBOutlet weak var searchCollecionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    var image: UIImage! 
    var movies = [Movie]() {
        didSet {
            DispatchQueue.main.async {
                self.searchCollecionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollecionView.delegate = self
        searchBar.delegate = self
        searchCollecionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailVC = segue.destination as! DetailViewController
            let cell = sender as! MovieCell
            if let indexPath = searchCollecionView.indexPath(for: cell) {
                detailVC.movie = movies[indexPath.row]
                detailVC.image = cell.imageView.image
            }
        }
    }
}

extension MovieSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        if !searchText.isEmpty {
            guard let encodedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            AppleMovieAPIService.shared.searchMovie(keyword: encodedString, completion: { (error, movies) in
                if let error = error {
                    let alertController = UIAlertController(title: "Error Occured", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else if let movies = movies {
                    self.movies = movies
                }
            })
        }
    }
}

extension MovieSearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        configureMovie(movie: movie, forCell: cell)
        return cell
    }
    
    func configureMovie(movie: Movie, forCell cell: MovieCell) {
        DispatchQueue.global().async {
            do {
                let imageData = try Data.init(contentsOf: movie.artworkUrl100)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage.init(data: imageData)
                }
            } catch {
                print("image processing error: \(error.localizedDescription)")
            }
        }
    }
}

extension MovieSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

