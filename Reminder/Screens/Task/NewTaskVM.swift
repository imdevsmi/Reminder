//
//  NewTaskVM.swift
//  Reminder
//
//  Created by Sami Gündoğan on 29.04.2025.
//

import Foundation

protocol NewTaskVMProtocol {
    func addTask(name: String, detail: String?, date: Date, time: Date, completion: @escaping (Task?) -> Void)
}

class NewTaskVM: NewTaskVMProtocol {
    private let taskManager: TaskStorageService

    init(taskManager: TaskStorageService = TaskStorageService()) {
        self.taskManager = taskManager
    }

    func addTask(name: String, detail: String?, date: Date, time: Date, completion: @escaping (Task?) -> Void) {
        let task = Task(
            id: UUID(),
            title: name,
            notes: detail,
            date: date,
            time: time,
            isCompleted: false
        )
        
        taskManager.insert(task)
        completion(task)
    }
}
