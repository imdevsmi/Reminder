//
//  TaskCellDelegate.swift
//  Reminder
//
//  Created by Sami Gündoğan on 30.04.2025.
//

import Foundation

protocol TaskCellDelegate: AnyObject {
    func didToggleTaskCompletion(_ task: Task)
}
