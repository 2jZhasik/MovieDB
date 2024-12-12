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
    private var movieDetail: MovieDetail?
    private lazy var genres: [Genre] = []

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset = UIEdgeInsets(top: 12, left: 25, bottom: view.safeAreaInsets.bottom + 20, right: 20)
        return scroll
    }()
    
    lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "GenreCell")
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var linkStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBackground
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
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
    
    private lazy var voteAvgLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private var imdbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imdb")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var youtubeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "youtube")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var facebookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "facebook")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var contentView = UIView()
   
    func apiRequest() {
        guard let movieId else { return }
        NetworkManager.shared.loadMovieDetail(movieId: movieId) { [weak self] result in
            guard let self = self else { return }
            movieDetail = result
            guard let movieDetail = movieDetail else { return }
            let imageUrl = NetworkManager.shared.baseImageUrl.appending(movieDetail.posterPath!)
            posterImageView.kf.setImage(with: URL(string: imageUrl))
            genres = movieDetail.genres
            titleLabel.text = movieDetail.title
            releaseDateLabel.text = "Release " + (releaseDateFormat(stringDate: movieDetail.releaseDate))
            setRatingStar(rating: movieDetail.voteAverage ?? 0)
            guard let voteCount = movieDetail.voteCount else { return }
            voteCountLabel.text = voteCount > 1000 ? "\((voteCount)/1000)K" : "\(voteCount)"
            voteAvgLabel.text = "\(String(format: "%.1f",movieDetail.voteAverage ?? 0))/10"
            genreCollectionView.reloadData()
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
            ratingStackView.addArrangedSubview(image)
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [releaseDateLabel, genreCollectionView].forEach { view in
            leftStackView.addArrangedSubview(view)
        }
        [ratingStackView, voteAvgLabel, voteCountLabel].forEach { view in
            rightStackView.addArrangedSubview(view)
        }
        [imdbImageView, youtubeImageView, facebookImageView].forEach { view in
            linkStackView.addArrangedSubview(view)
        }
        [posterImageView, titleLabel, leftStackView, rightStackView, linkStackView].forEach { view in
            contentView.addSubview(view)
        }
                
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        
//        let posterHeight = view.bounds.height * 0.6
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(460)
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(posterImageView.snp.width)
        }
        
        genreCollectionView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        voteCountLabel.snp.makeConstraints { make in
            make.top.equalTo(voteAvgLabel.snp.bottom)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.2)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(leftStackView.snp.trailing)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.3)
        }
        
        imdbImageView.snp.makeConstraints { make in
            make.width.equalTo(87)
            make.height.equalTo(44)
        }
        
        youtubeImageView.snp.makeConstraints { make in
            make.width.equalTo(63)
            make.height.equalTo(44)
        }
        
        facebookImageView.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        linkStackView.snp.makeConstraints { make in
            make.top.equalTo(leftStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        youtubeImageView.addGestureRecognizer(tapGR)
        youtubeImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped() {
        guard let movieId else { return }
        NetworkManager.shared.loadVideos(movieId: movieId) { videos in
            let youtubeVideos = videos.filter { video in
                if let site = video.site {
                    site.contains("YouTube")
                } else { .init() }
            }
            guard let key = youtubeVideos.first?.key else { return }
            let urlString = "https://www.youtube.com/watch?v=" + key
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCollectionViewCell
        cell.genreLabel.text = genres[indexPath.row].name
        cell.configureLabel(font: .systemFont(ofSize: 14, weight: .regular))
        return cell
    }
}
