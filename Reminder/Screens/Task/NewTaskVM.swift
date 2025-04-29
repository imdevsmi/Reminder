//
//  NewTaskVM.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import Foundation

protocol NewTaskVMProtocol: AnyObject {
    
    func addTask(name: String, detail: String?, date: Date, time: Date)
}

final class NewTaskVM: NewTaskVMProtocol {
    private let taskManager = TaskStorageService()

    func addTask(name: String, detail: String?, date: Date, time: Date) {
        let task = Task(
            id: UUID(),
            title: name,
            notes: detail,
            date: date,
            time: time,
            isCompleted: false)
        
        taskManager.insert(task)
    }
}
