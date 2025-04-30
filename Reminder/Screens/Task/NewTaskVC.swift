//
//  NewTaskVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import UIKit


class NewTaskVC: UIViewController {
    
    private let viewModelNewTask: NewTaskVMProtocol = NewTaskVM()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
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
        label.text = "Sat, 29 March"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Add Blur effect to the background
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
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
        
        
        
        view.addSubview(newTaskView)
        view.addSubview(saveTaskButton)
        view.addSubview(taskDatePicker)
        
        NSLayoutConstraint.activate([
            newTaskView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            newTaskView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            newTaskView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            newTaskView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            contentVerticalStackView.topAnchor.constraint(equalTo: newTaskView.topAnchor, constant: 16),
            contentVerticalStackView.leadingAnchor.constraint(equalTo: newTaskView.leadingAnchor, constant: 16),
            contentVerticalStackView.trailingAnchor.constraint(equalTo: newTaskView.trailingAnchor, constant: -16),
            
            saveTaskButton.bottomAnchor.constraint(equalTo: newTaskView.bottomAnchor, constant: -16),
            saveTaskButton.trailingAnchor.constraint(equalTo: newTaskView.trailingAnchor, constant: -16),
            saveTaskButton.heightAnchor.constraint(equalTo: newTaskView.heightAnchor, multiplier: 0.09),
            saveTaskButton.widthAnchor.constraint(equalTo: newTaskView.widthAnchor, multiplier: 0.20),
            
            taskDatePicker.topAnchor.constraint(equalTo: calendarStackView.bottomAnchor, constant: 8),
            taskDatePicker.leadingAnchor.constraint(equalTo: newTaskView.leadingAnchor),
            taskDatePicker.trailingAnchor.constraint(equalTo: newTaskView.trailingAnchor, constant: -48)])
    }
    
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

        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            let alert = UIAlertController(title: "Missing Name", message: "Please enter a task name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        viewModelNewTask.addTask(name: name, detail: detail, date: date, time: time)

       
        NotificationCenter.default.post(name: .didAddNewTask, object: nil)

        dismiss(animated: true)
    }
    
    @objc func showDatePicker() {
        taskDatePicker.isHidden.toggle()
    }
}

#Preview {
    NewTaskVC()
}
