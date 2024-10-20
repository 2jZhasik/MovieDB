//
//  ViewController.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 07.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Result] = []
    
    lazy var movieDBLabel: UILabel = {
       let label = UILabel()
        label.text = "MovieDB"
        label.font = UIFont.systemFont(ofSize: 36,weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        apiRequest()
        setupLayout()
    }
    
    func apiRequest() {
        NetworkManager.shared.loadMovie { result in
            self.movies = result.results
            self.movieTableView.reloadData()
        }
    }

    func setupLayout() {
        
        [movieDBLabel, movieTableView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            movieDBLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            movieDBLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieDBLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            movieTableView.topAnchor.constraint(equalTo: movieDBLabel.bottomAnchor, constant: 25),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
        let movie = movies[indexPath.row]
        NetworkManager.shared.loadImage(posterPath: movie.posterPath) { image in
            cell.posterImageView.image = image
        }
        cell.titleLabel.text = movie.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let vc = MovieDetailViewController()
        vc.movieId = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
}
