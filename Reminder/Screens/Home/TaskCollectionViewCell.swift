//
//  TaskCollectionViewCell.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import SnapKit
import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TaskCellDelegate?
    private var task: Task?
    static let reuseIdentifier = "TaskCell"
    
    private var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        
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
        let normalConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let normalImage = UIImage(systemName: "circle", withConfiguration: normalConfig)
        let selectedConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .medium)
        let selectedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: selectedConfig)
        
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.tintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        
        button.setPreferredSymbolConfiguration(normalConfig, forImageIn: .normal)
        button.setPreferredSymbolConfiguration(selectedConfig, forImageIn: .selected)
        
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
        layer.cornerRadius = 8
        layer.masksToBounds = true
        alpha = 1.0
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        contentView.addSubview(taskTitleLabel)
        contentView.addSubview(taskTimeLabel)
        contentView.addSubview(checkboxButton)
        
        checkboxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
        
        taskTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(checkboxButton.snp.leading).offset(-8)
        }
        
        taskTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(taskTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(taskTitleLabel)
            make.bottom.equalToSuperview().offset(-12)
        }
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        checkboxButton.tintColor = .black
        checkboxButton.isSelected.toggle()
        guard var task = self.task else { return }
        task.isCompleted = checkboxButton.isSelected
        task.time = task.isCompleted ? Date() : nil
        saveTaskState(task)
        delegate?.didToggleTaskCompletion(task)
    }

    private func saveTaskState(_ task: Task) {
        let defaults = UserDefaults.standard
        defaults.set(task.isCompleted, forKey: "\(task.id)_completed")
        defaults.synchronize()
    }
    
    func configure(with task: Task) {
        self.task = task
        let persistedCompleted = UserDefaults.standard.bool(forKey: "\(task.id)_completed")
        var updatedTask = task
        updatedTask.isCompleted = persistedCompleted
        
        let isDark = traitCollection.userInterfaceStyle == .dark
        let isCompleted = updatedTask.isCompleted

        // MARK: - Background & Border
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = isDark ? .black : .white

        let borderColor: UIColor = {
            if isDark {
                return isCompleted
                    ? UIColor.white.withAlphaComponent(0.3)
                    : UIColor.white
            } else {
                return isCompleted
                    ? UIColor.black.withAlphaComponent(0.3)
                    : UIColor.black
            }
        }()
        contentView.layer.borderColor = borderColor.cgColor

        // MARK: - Labels
        let textColor: UIColor = isDark
            ? UIColor.white.withAlphaComponent(0.75)
            : (isCompleted ? UIColor.black.withAlphaComponent(0.75) : UIColor.black)

        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        [taskTitleLabel, taskDescriptionLabel, taskTimeLabel].forEach {
            $0.textColor = textColor
            $0.font = font
        }

        taskTitleLabel.text = updatedTask.title
        taskDescriptionLabel.text = updatedTask.notes
        taskTimeLabel.text = updatedTask.completedText

        // MARK: - Checkbox Icon
        let config = UIImage.SymbolConfiguration(pointSize: 31.5, weight: .semibold)

        let (symbolName, tint): (String, UIColor) = {
            if isCompleted {
                let color = isDark
                    ? UIColor.white.withAlphaComponent(0.75)
                    : UIColor.black.withAlphaComponent(0.75)
                return ("checkmark.circle.fill", color)
            } else {
                let color = isDark ? UIColor.white : UIColor.black
                return ("circle", color)
            }
        }()

        let iconImage = UIImage(systemName: symbolName, withConfiguration: config)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(tint)

        checkboxButton.setImage(iconImage, for: .normal)
        checkboxButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        checkboxButton.isSelected = isCompleted
    }
}
