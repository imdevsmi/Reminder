//
//  TaskCollectionViewCell.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TaskCell"
    
    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let taskTimeLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let taskDescriptionLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let checkboxButton: UIButton = {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.tintColor = .systemGray3
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        
        backgroundColor = .systemBackground
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        contentView.addSubview(taskTitleLabel)
        contentView.addSubview(taskTimeLabel)
        contentView.addSubview(checkboxButton)
        
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            taskTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            taskTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            taskTitleLabel.trailingAnchor.constraint(equalTo: checkboxButton.leadingAnchor, constant: -8),
            
            taskTimeLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 4),
            taskTimeLabel.leadingAnchor.constraint(equalTo: taskTitleLabel.leadingAnchor),
            taskTimeLabel.trailingAnchor.constraint(equalTo: taskTitleLabel.trailingAnchor),
            taskTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        checkboxButton.isSelected.toggle()
    }
    
    func configure(with task: Task) {
        taskTitleLabel.text = task.title
        taskDescriptionLabel.text = task.notes
        taskTimeLabel.text = ""
        checkboxButton.isSelected = task.isCompleted
        
        if task.isCompleted {
            if let completionTime = task.time as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                taskTimeLabel.text = "completed in \(formatter.string(from: completionTime))"
            }
        } else {
            taskTimeLabel.text = task.notes
        }
    }
}
