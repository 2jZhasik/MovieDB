//
//  ViewController.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 07.10.2024.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    private var allMovies: [Result] = []
    private lazy var movies: [Result] = []
    private lazy var genres: [Genre] = [.init(id: 1, name: "All")]

    lazy var movieDBLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieDB"
        label.font = UIFont.systemFont(ofSize: 36,weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
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
    
    lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 22, bottom: 10, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "GenreCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = movieDBLabel
        apiRequest()
        setupLayout()
    }

    private func apiRequest() {
        NetworkManager.shared.loadMovie { [weak self] result in
            self?.allMovies = result.results
            self?.movies = result.results
            self?.movieTableView.reloadData()
        }
        
        NetworkManager.shared.loadGenres { [weak self] result in
            result.genres.forEach { genre in
                self?.genres.append(genre)
            }
            self?.genreCollectionView.reloadData()
        }
    }
    
    private func obtainMovieList(with genreId: Int) {
        guard genreId != 1 else {
            movies = allMovies
            return
        }
        
        movies = allMovies.filter { movies in
            movies.genreIDS.contains(genreId)
        }
    }

    func setupLayout() {
        
        [genreCollectionView, movieTableView].forEach {
            view.addSubview($0)
        }
        
        genreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(60)
        }
        
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(genreCollectionView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
        let movie = movies[indexPath.row]
        let imageUrl = NetworkManager.shared.baseImageUrl.appending(movie.posterPath)
        cell.posterImageView.kf.setImage(with: URL(string: imageUrl))
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

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCollectionViewCell
        cell.genreLabel.text = genres[indexPath.row].name
        cell.configureLabel(font: .systemFont(ofSize: 18, weight: .regular))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        obtainMovieList(with: genres[indexPath.row].id!)
        movieTableView.reloadData()
    }
}
