//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Sasha Soldatov on 25.03.2026.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    static let reuseID = "HabitCollectionViewCell"
    private var habit: Habit?
    var onTrack: (() -> Void)?
    
    //MARK: - Subviews
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.numberOfLines = 2
        return nameLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .systemGray2
        return dateLabel
    }()
    
    private let counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        counterLabel.textColor = .systemGray
        return counterLabel
    }()
    
    private let checkButton: UIButton = {
        let checkButton = UIButton(type: .system)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        return checkButton
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(checkButton)
        
        checkButton.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            counterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            checkButton.widthAnchor.constraint(equalToConstant: 38),
            checkButton.heightAnchor.constraint(equalToConstant: 38),
        ])
    }
    
    //MARK: - Configure
    
    func configure(with habit: Habit) {
        self.habit = habit
        nameLabel.text = habit.name
        nameLabel.textColor = habit.color
        dateLabel.text = habit.dateString
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        updateCheckButton()
    }
    
    private func updateCheckButton() {
        guard let habit = habit else { return }
        let color = habit.color
        let size = UIImage.SymbolConfiguration(pointSize: 36)
        
        if habit.isAlreadyTakenToday {
            let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: size)
            checkButton.setImage(image, for: .normal)
            checkButton.tintColor = color
        } else {
            let image = UIImage(systemName: "circle", withConfiguration: size)
            checkButton.setImage(image, for: .normal)
            checkButton.tintColor = color
        }
    }
    
    //MARK: - Actions
    @objc private func checkTapped() {
        guard let habit = habit, !habit.isAlreadyTakenToday else { return }
        HabitsStore.shared.track(habit)
        updateCheckButton()
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"
        onTrack?()
    }
}
