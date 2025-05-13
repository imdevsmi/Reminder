//
//  DateCell.swift
//  Reminder
//
//  Created by Sami Gündoğan on 1.05.2025.
//

import SnapKit
import UIKit

class DateCell: UICollectionViewCell {
    static let identifier = "DateCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let todayIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [dayLabel, dateLabel, todayIndicator].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        todayIndicator.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(12)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }

    func configure(with date: Date, isToday: Bool) {
        dayLabel.text = date.formatted(.dateTime.month(.abbreviated)).uppercased()
        dateLabel.text = date.formatted(.dateTime.day())
        todayIndicator.isHidden = !isToday
        updateSelectionStyle()
    }
    
    private func updateSelectionStyle() {
        let isDark = isSelected
        contentView.backgroundColor = isDark ? .label : .clear
        dayLabel.textColor = isDark ? .systemBackground : .label
        dateLabel.textColor = isDark ? .systemBackground : .label
        contentView.layer.cornerRadius = 12
    }
}
