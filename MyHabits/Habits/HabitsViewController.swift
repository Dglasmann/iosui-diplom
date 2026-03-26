//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Sasha Soldatov on 23.03.2026.
//

import UIKit

class HabitsViewController: UIViewController {
    
    
    //MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.reuseID)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.reuseID)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Сегодня"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHabitTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        
        setupViews()
        setupConstraints()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: - Constratins
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    //MARK: - Actions
    @objc private func addHabitTapped() {
        let habitVC = HabitViewController()
        habitVC.onSave = { [weak self] in
            self?.collectionView.reloadData()
        }
        let nav = UINavigationController(rootViewController: habitVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

    //MARK: - Extensions
extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return HabitsStore.shared.habits.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.reuseID, for: indexPath) as! ProgressCollectionViewCell
            cell.configure(progress: HabitsStore.shared.todayProgress)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.reuseID, for: indexPath) as! HabitCollectionViewCell
            
            let habit = HabitsStore.shared.habits[indexPath.item]
            cell.configure(with: habit)
            cell.onTrack = { [weak self] in
                self?.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        switch indexPath.section {
        case 0: return CGSize(width: width, height: 60)
        case 1: return CGSize(width: width, height: 130)
        default: return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0: return UIEdgeInsets(top: 22, left: 16, bottom: 6, right: 16)
        case 1: return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        default: return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let habit = HabitsStore.shared.habits[indexPath.item]
        let detailsVC = HabitDetailsViewController(habit: habit)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

