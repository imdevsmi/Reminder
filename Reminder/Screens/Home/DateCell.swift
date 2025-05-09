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

    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    private let todayIndicator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
        styleViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(todayIndicator)
    }

    private func layoutViews() {
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
            make.width.height.equalTo(6)
        }
    }

    private func styleViews() {
        dayLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)

        dayLabel.textAlignment = .center
        dateLabel.textAlignment = .center

        todayIndicator.layer.cornerRadius = 3
        todayIndicator.backgroundColor = .systemBlue
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }

    func configure(with date: Date, isToday: Bool) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "MMM"
        dayLabel.text = dayFormatter.string(from: date).uppercased()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        dateLabel.text = dateFormatter.string(from: date)

        todayIndicator.isHidden = !isToday
        updateSelectionStyle()
    }

    private func updateSelectionStyle() {
        if isSelected {
            contentView.backgroundColor = .label
            dayLabel.textColor = .systemBackground
            dateLabel.textColor = .systemBackground
        } else {
            contentView.backgroundColor = .clear
            dayLabel.textColor = .label
            dateLabel.textColor = .label
        }

        contentView.layer.cornerRadius = 12
    }
}
