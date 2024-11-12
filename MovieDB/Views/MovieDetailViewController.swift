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
    
    private lazy var starStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
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
        label.numberOfLines = 0
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
            self.releaseDateLabel.text = "Release " + releaseDateFormat(stringDate: movieDetail.releaseDate)
            self.setRatingStar(rating: movieDetail.voteAverage ?? 0)
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
    
    private func setRatingStar(rating: Double) {
        let rating = rating / 2
        let fullStar = UIImage(systemName: "star.fill")
        let star = UIImage(systemName: "star")
        let halfStar = UIImage(systemName: "star.leadinghalf.filled")
        for i in 0..<5 {
            let image = UIImageView()
            image.tintColor = .systemYellow
            if rating >= Double(i) {
                image.image = fullStar
            }
            else if rating >= Double(i) - 0.5 {
                image.image = halfStar
            }
            else {
                image.image = star
            }
            starStackView.addArrangedSubview(image)
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        [posterImageView, titleLabel, releaseDateLabel, starStackView].forEach { view in
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
            make.width.equalToSuperview().dividedBy(2.24)
        }
        
        starStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(releaseDateLabel.snp.trailing).offset(22)
            make.trailing.equalToSuperview().offset(22)
        }
    }
}
