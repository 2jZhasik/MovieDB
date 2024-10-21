//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 17.10.2024.
//

import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    var movieId: Int?
    var movieDetail: MovieDetail?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiRequest()
        setupLayout()
        title = "Movie"
    }
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
   
    func apiRequest() {
        guard let movieId else { return }
        NetworkManager.shared.loadMovieDetail(movieId: movieId) { [self] result in
            self.movieDetail = result
            guard let movieDetail = self.movieDetail else { return }
            NetworkManager.shared.loadImage(posterPath: movieDetail.posterPath!) { result in
                self.posterImageView.image = result
            }
            self.titleLabel.text = movieDetail.title
            self.releaseDateLabel.text = "Release date " + releaseDateFormat(stringDate: movieDetail.releaseDate)
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        [posterImageView, titleLabel, releaseDateLabel].forEach { view in
            scrollView.addSubview(view)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(424)
            make.width.equalTo(309)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(posterImageView.snp.width)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(22)
        }
    }
    
    func releaseDateFormat(stringDate: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let stringDate = stringDate else { return "Something went wrong" }
        guard let date = dateFormatter.date(from: stringDate) else { return "unknown" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy"
        return outputFormatter.string(from: date)
    }
}
