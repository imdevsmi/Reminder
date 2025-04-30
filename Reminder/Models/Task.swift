//
//  Task.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import Foundation

struct Task: Codable, Identifiable, Equatable {
    
    let id: UUID
    var title: String
    var notes: String? // task detail
    var date: Date
    var time: Date?
    var isCompleted: Bool
    
    init (id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        date: Date,
        time: Date,
        isCompleted: Bool = false) {
        
        self.id = id
        self.title = title
        self.notes = notes
        self.date = date
        self.time = time
        self.isCompleted = isCompleted
    }
}
