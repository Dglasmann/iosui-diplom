//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Sasha Soldatov on 25.03.2026.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    static let reuseID = "ProgressCollectionViewCell"
    
    
    //MARK: - Subviews
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Всё получится!"
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .systemGray
        return titleLabel
    }()
    
    private let percentLabel: UILabel = {
        let percentLabel = UILabel()
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        percentLabel.textColor = .systemGray
        return percentLabel
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        progressView.trackTintColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        progressView.layer.cornerRadius = 3.5
        progressView.clipsToBounds = true
        return progressView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.addSubview(titleLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(progressView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    //MARK: - Configure
    
    func configure(progress: Float) {
        progressView.setProgress(progress, animated: true)
        percentLabel.text = "\(Int(progress * 100))%"
    }
}
