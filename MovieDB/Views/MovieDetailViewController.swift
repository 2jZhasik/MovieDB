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
   
    func apiRequest() {
        guard let movieId else { return }
        NetworkManager.shared.loadMovieDetail(movieId: movieId) { result in
            self.movieDetail = result
            guard let movieDetail = self.movieDetail else { return }
            NetworkManager.shared.loadImage(posterPath: movieDetail.posterPath!) { result in
                self.posterImageView.image = result
            }
            self.titleLabel.text = movieDetail.title
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        [posterImageView, titleLabel].forEach { view in
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
    }
}
