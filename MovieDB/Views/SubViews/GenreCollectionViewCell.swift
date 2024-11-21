//
//  GenreCollectionViewCell.swift
//  MovieDB
//
//  Created by Елжас Бегланулы on 21.10.2024.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemBlue : .systemGray6
            genreLabel.textColor = isSelected ? .white : .black
        }
    }
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(font: UIFont) {
        self.genreLabel.font = font
    }
    
    func configureBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    private func setupUI() {
        contentView.addSubview(genreLabel)
        clipsToBounds = true
        layer.cornerRadius = 11
        genreLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
