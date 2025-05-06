//
//  TaskCollectionViewCell.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import UIKit
import SnapKit

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
        checkboxButton.isSelected.toggle()
        guard var task = self.task else { return }
        task.isCompleted = checkboxButton.isSelected
        task.time = task.isCompleted ? Date() : nil
        delegate?.didToggleTaskCompletion(task)
        
        if checkboxButton.isSelected {
            checkboxButton.tintColor = .black
        } else {
            checkboxButton.tintColor = .black
        }
    }
    
    func configure(with task: Task) {
        self.task = task
        taskTitleLabel.text = task.title
        taskDescriptionLabel.text = task.notes
        checkboxButton.isSelected = task.isCompleted
        taskTimeLabel.text = task.completedText

        // Metin renklerini ayarlama (gri ve kalın)
        taskTitleLabel.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .gray
        }
        taskTitleLabel.font = UIFont.boldSystemFont(ofSize: 16) // Kalın

        taskDescriptionLabel.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .gray
        }
        taskDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 14) // Kalın

        taskTimeLabel.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .gray
        }
        taskTimeLabel.font = UIFont.boldSystemFont(ofSize: 14) // Kalın

        // Checkbox rengi (tik işareti ve çemberin içi)
        checkboxButton.tintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }

        // Çemberin içi gri, tik siyah
        let normalConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let normalImage = UIImage(systemName: "circle.fill", withConfiguration: normalConfig) // Gri çember

        let selectedConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .medium)
        let selectedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: selectedConfig) // Siyah tik

        checkboxButton.setImage(normalImage, for: .normal) // Normal durumda gri çember
        checkboxButton.setImage(selectedImage, for: .selected) // Seçili durumda siyah tik
        checkboxButton.setPreferredSymbolConfiguration(normalConfig, forImageIn: .normal)
        checkboxButton.setPreferredSymbolConfiguration(selectedConfig, forImageIn: .selected)

        // ContentView arka plan rengi (siyah kutucuk)
        contentView.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .darkGray : .lightGray // Daha belirgin kutucuklar
        }
    }
}
