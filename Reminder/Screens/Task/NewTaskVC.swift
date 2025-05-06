//
//  NewTaskVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import SnapKit
import UIKit

// MARK: - NewTaskVC
class NewTaskVC: UIViewController {
    
    // MARK: - Properties
    private let viewModelNewTask: NewTaskVMProtocol = NewTaskVM()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    // MARK: - UI Elements
    private lazy var newTaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let newTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "New Task"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Remind"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var clockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let clockIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "clock"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "12:00 pm"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        stackView.addGestureRecognizer(recognizer)
        
        return stackView
    }()
    
    private lazy var taskDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.isHidden = true
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .green
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        picker.layer.borderColor = UIColor.red.cgColor
        picker.layer.borderWidth = 1
        picker.tintColor = .label
        picker.layer.cornerRadius = 8
        
        return picker
    }()
    
    private let calenderIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMMM"
        label.text = formatter.string(from: Date())
        
        return label
    }()
    
    private lazy var newTaskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Here will be the text of the new task."
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .secondaryLabel
        textField.font = .preferredFont(forTextStyle: .body)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var saveTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveTaskButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = UIColor.clear
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.addSubview(newTaskView)
        newTaskView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.90)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
        setupUI()
    }
    
    // MARK: - UI Setup (SnapKit)
    private func setupUI() {
        view.addSubview(blurEffectView)
        view.addSubview(newTaskView)
        view.addSubview(saveTaskButton)
        view.addSubview(taskDatePicker)
        blurEffectView.frame = view.bounds
        newTaskView.addSubview(contentVerticalStackView)
        
        calendarStackView.addArrangedSubview(calenderIcon)
        calendarStackView.addArrangedSubview(dateLabel)
        clockStackView.addArrangedSubview(clockIcon)
        clockStackView.addArrangedSubview(timeLabel)
        
        contentVerticalStackView.addArrangedSubview(newTaskLabel)
        contentVerticalStackView.addArrangedSubview(dateTitleLabel)
        contentVerticalStackView.addArrangedSubview(calendarStackView)
        contentVerticalStackView.addArrangedSubview(clockStackView)
        contentVerticalStackView.addArrangedSubview(newTaskTextField)
        
        newTaskView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.90)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
        
        contentVerticalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        saveTaskButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(newTaskView).inset(16)
            make.height.equalTo(newTaskView).multipliedBy(0.09)
            make.width.equalTo(newTaskView).multipliedBy(0.20)
        }
        
        taskDatePicker.snp.makeConstraints { make in
            make.top.equalTo(calendarStackView.snp.bottom).offset(8)
            make.leading.equalTo(newTaskView)
            make.trailing.equalTo(newTaskView).offset(-48)
        }
    }
    
    // MARK: - Actions
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMMM"
        dateLabel.text = formatter.string(from: sender.date)
        taskDatePicker.date = sender.date
    }
    
    @objc private func saveTaskButtonTapped() {
        let name = newTaskTextField.text ?? ""
        let detail: String? = nil
        let date = taskDatePicker.date
        let time = taskDatePicker.date
        
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            let alert = UIAlertController(
                title: "Missing Name",
                message: "Please enter a task name",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        viewModelNewTask.addTask(name: name, detail: detail, date: date, time: time) { [weak self] newTask in
            guard let self = self, let task = newTask else {
                let errorAlert = UIAlertController(
                    title: "Error",
                    message: "Task could not be saved.",
                    preferredStyle: .alert
                )
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(errorAlert, animated: true)
                return
            }
            
            NotificationCenter.default.post(name: .didAddNewTask, object: task)
            self.dismiss(animated: true)
        }
    }
    
    @objc func showDatePicker() {
        taskDatePicker.isHidden.toggle()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
