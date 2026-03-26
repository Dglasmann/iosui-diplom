//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Sasha Soldatov on 24.03.2026.
//
import UIKit

class HabitViewController: UIViewController {
    
    //MARK: - Properties
    var habitToEdit: Habit?
    
    var onSave: (() -> Void)?
    
    private var selectedColor: UIColor = UIColor(red: 255/255, green: 159/255, blue: 79/255, alpha: 1)
    
    //MARK: - Subviews
    private let nameTitleLabel: UILabel = {
        let nameTitleLabel = UILabel()
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.text = "НАЗВАНИЕ"
        nameTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        nameTitleLabel.textColor = .black
        return nameTitleLabel
    }()
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        nameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameTextField.returnKeyType = .done
        return nameTextField
    }()
    
    private let colorTitleLabel: UILabel = {
        let colorTitleLabel = UILabel()
        colorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        colorTitleLabel.text = "ЦВЕТ"
        colorTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        colorTitleLabel.textColor = .black
        return colorTitleLabel
    }()
    
    private lazy var colorCircle: UIView = {
        let colorCircle = UIView()
        colorCircle.translatesAutoresizingMaskIntoConstraints = false
        colorCircle.layer.cornerRadius = 15
        colorCircle.backgroundColor = selectedColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(colorCircleTapped))
        colorCircle.addGestureRecognizer(tap)
        return colorCircle
    }()
    
    private let timeTitleLabel: UILabel = {
        let timeTitleLabel = UILabel()
        timeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTitleLabel.text = "ВРЕМЯ"
        timeTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        timeTitleLabel.textColor = .black
        return timeTitleLabel
    }()
    
    private let timeDescriptionLabel: UILabel = {
        let timeDescriptionLabel = UILabel()
        timeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        timeDescriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        timeDescriptionLabel.textColor = .black
        return timeDescriptionLabel
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Удалить привычку", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.isHidden = true
        return deleteButton
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = habitToEdit == nil ? "Создать" : "Править"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .prominent,
            target: self,
            action: #selector(saveTapped)
        )
        let purple = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = purple
        navigationItem.rightBarButtonItem?.tintColor = purple
        
        nameTextField.delegate = self
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        setupViews()
        setupConstraints()
        fillIfEditing()
        updateTimeLabel()
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(colorTitleLabel)
        view.addSubview(colorCircle)
        view.addSubview(timeTitleLabel)
        view.addSubview(timeDescriptionLabel)
        view.addSubview(datePicker)
        view.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 7),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            colorTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            colorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            colorCircle.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 7),
            colorCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorCircle.widthAnchor.constraint(equalToConstant: 30),
            colorCircle.heightAnchor.constraint(equalToConstant: 30),
            
            timeTitleLabel.topAnchor.constraint(equalTo: colorCircle.bottomAnchor, constant: 15),
            timeTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            timeDescriptionLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 7),
            timeDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: timeDescriptionLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
        ])
    }
    
    private func fillIfEditing() {
        guard let habit = habitToEdit else { return }
        nameTextField.text = habit.name
        selectedColor = habit.color
        nameTextField.textColor = selectedColor
        colorCircle.backgroundColor = habit.color
        datePicker.date = habit.date
        deleteButton.isHidden = false
    }
    
    private func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.timeStyle = .short
        
        let timeString = formatter.string(from: datePicker.date)
        let text = "Каждый день в "
        let attributed = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.black,
        ])
        
        let purple = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        attributed.append(NSAttributedString(string: timeString, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: purple,
        ]))
        timeDescriptionLabel.attributedText = attributed
    }
    
    //MARK: - Actions
    
    @objc private func dateChanged() {
        updateTimeLabel()
    }
    
    @objc private func colorCircleTapped() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = selectedColor
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        let name = nameTextField.text ?? ""
        
        if let habit = habitToEdit {
            habit.name = name
            habit.color = selectedColor
            habit.date = datePicker.date
            HabitsStore.shared.save()
        } else {
            let newHabit = Habit(name: name, date: datePicker.date, color: selectedColor)
            HabitsStore.shared.habits.append(newHabit)
        }
        onSave?()
        dismiss(animated: true)
    }
    
    @objc private func deleteTapped() {
        guard let habit = habitToEdit else { return }
        
        let alert = UIAlertController(
            title: "Удалить привычку",
            message: "Вы хотите удалить привычку \"\(habit.name)\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            if let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits.remove(at: index)
            }
            self?.onSave?()
            self?.dismiss(animated: false) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = scene.windows.first,
                   let tabBar = window.rootViewController as? UITabBarController,
                   let nav = tabBar.viewControllers?.first as? UINavigationController {
                    nav.popToRootViewController(animated: true)
                }
            }
            
        })
        present(alert, animated: true)
    }
    
}

extension HabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorCircle.backgroundColor = selectedColor
    }
}



