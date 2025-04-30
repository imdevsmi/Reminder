//
//  Date.swift
//  Reminder
//
//  Created by Sami Gündoğan on 30.04.2025.
//

import Foundation

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
