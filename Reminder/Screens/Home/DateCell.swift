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

    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        dateLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with date: Date, isToday: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"

        dateLabel.text = formatter.string(from: date)

        if Calendar.current.isDateInToday(date) {
            dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
            dateLabel.textColor = .black
        } else {
            dateLabel.font = UIFont.systemFont(ofSize: 14)
            dateLabel.textColor = .lightGray
        }
    }
}
