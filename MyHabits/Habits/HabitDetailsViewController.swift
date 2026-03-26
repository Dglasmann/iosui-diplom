//
//  HabitDetailViewController.swift
//  MyHabits
//
//  Created by Sasha Soldatov on 26.03.2026.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    
    //MARK: - Properties
    private let habit: Habit
    
    //MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        return tableView
    }()
    
    //MARK: - Init
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = habit.name
        
        let purple = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Править",
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = purple
        
        setupViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = habit.name
        tableView.reloadData()
    }
    
    //MARK: - Setup
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    //MARK: - Actions
    
    @objc private func editTapped() {
        let editVC = HabitViewController()
        editVC.habitToEdit = habit
        editVC.onSave = { [weak self] in
            self?.title = self?.habit.name
            self?.tableView.reloadData()
        }
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
}
    //MARK: - Extensions
extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        
        let reversedIndex = HabitsStore.shared.dates.count - 1 - indexPath.row
        let date = HabitsStore.shared.dates[reversedIndex]
        
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: reversedIndex)
        
        let purple = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        if HabitsStore.shared.habit(habit, isTrackedIn: date) {
            cell.accessoryType = .checkmark
            cell.tintColor = purple
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
}

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
