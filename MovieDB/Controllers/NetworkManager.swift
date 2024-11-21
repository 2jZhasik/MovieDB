//
//  NetworkManager.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 08.10.2024.
//

import UIKit

class NetworkManager {
    static var shared = NetworkManager()
    
    private let apiKey = "5779257f891a383b969a3184246d5d99"
    private let session = URLSession(configuration: .default)
    private let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    
    private lazy var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return urlComponents
    }()
    
    func loadMovie(completion: @escaping (Movie)->()) {
        urlComponents.path = "/3/movie/now_playing"
        guard let url = urlComponents.url else { return }
        DispatchQueue.global().async {
            let task = self.session.dataTask(with: url) { data, _, error in
                if let error { print(error) }
                guard let data = data else { return }
                if let movie = try? JSONDecoder().decode(Movie.self, from: data) {
                    DispatchQueue.main.async {
                        completion(movie)
                    }
                }
            }
            task.resume()
        }
    }
    
    func loadImage(posterPath: String, completion: @escaping (UIImage)->()) {
        let url = baseImageUrl + posterPath
        guard let url = URL(string: url) else { return }
        let task = session.dataTask(with: url) { data, _, error in
            if let error {
                print(error)
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
        task.resume()
    }
    
    func loadMovieDetail(movieId: Int, completion: @escaping (MovieDetail)->()) {
        urlComponents.path = "/3/movie/\(movieId)"
        guard let url = urlComponents.url else { return }
        let task = session.dataTask(with: url) { data, _, error in
            if let error {
                print(error)
            }
            guard let data = data else { return }
            if let movieDetail = try? JSONDecoder().decode(MovieDetail.self, from: data) {
                DispatchQueue.main.async {
                    completion(movieDetail)
                }
            }
        }
        task.resume()
    }
    
    func loadGenres(completion: @escaping (Genres)->()) {
        urlComponents.path = "/3/genre/movie/list"
        guard let url = urlComponents.url else { return }
        DispatchQueue.global().async {
            let task = self.session.dataTask(with: url) { data, _, error in
                if let error { print(error) }
                guard let data = data else { return }
                if let genres = try? JSONDecoder().decode(Genres.self, from: data) {
                    DispatchQueue.main.async {
                        completion(genres)
                    }
                }
            }
            task.resume()
        }
    }
}
