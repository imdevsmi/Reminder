//
//  HomeVM.swift
//  Reminder
//
//  Created by Sami Gündoğan on 28.04.2025.
//

import Foundation

protocol HomeVMProtocol: AnyObject {
    var greetingText: String { get }
    var availableDates: [Date] { get }
    var selectedDate: Date? { get set }
    var tasksForSelectedDate: [Task] { get }
    
    var onTasksUpdated: (() -> Void)? { get set }
    
    func loadAvailableDates(for numberOfDays: Int)
    func updateSelectedDate(at index: Int)
    func loadTasksFromStorage()
    func addNewTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(with id: UUID)
}

final class HomeVM: HomeVMProtocol {
    
    // MARK: - Dependencies
    var onTasksUpdated: (() -> Void)?
    private let storageService = TaskStorageService()

    // MARK: - State
    private var allTasks: [Task] = [] {
        didSet {
            updateTasksForSelectedDate()
        }
    }
    
    private(set) var availableDates: [Date] = []
    private(set) var tasksForSelectedDate: [Task] = []
    
    var selectedDate: Date? {
        didSet {
            updateTasksForSelectedDate()
        }
    }

    var greetingText: String {
        let name = UserDefaults.standard.string(forKey: "userName") ?? "Sami"
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        switch hour {
        case 6..<12: greeting = "Good Morning"
        case 12..<17: greeting = "Good Afternoon"
        case 17..<21: greeting = "Good Evening"
        default: greeting = "Good Night"
        }
        return "\(greeting) \(name)"
    }

    // MARK: - Public Methods
    func loadAvailableDates(for numberOfDays: Int) {
        let calendar = Calendar.current
        let today = Date()
        let startDay = calendar.date(byAdding: .day, value: -3, to: today)!

        availableDates = (0..<(numberOfDays + 3)).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startDay)
        }
    }

    func updateSelectedDate(at index: Int) {
        guard availableDates.indices.contains(index) else { return }
        selectedDate = availableDates[index]
    }

    func loadTasksFromStorage() {
        allTasks = storageService.retrieve()
        updateTasksForSelectedDate()
        onTasksUpdated?()
    }

    func addNewTask(_ task: Task) {
        storageService.insert(task)
        loadTasksFromStorage()
    }

    func updateTask(_ task: Task) {
        storageService.update(task)
        loadTasksFromStorage()
    }

    func deleteTask(with id: UUID) {
        storageService.deleteTask(with: id)
        loadTasksFromStorage()
    }

    // MARK: - Private
    private func updateTasksForSelectedDate() {
        guard let selectedDate = selectedDate else {
            tasksForSelectedDate = []
            return
        }
        
        tasksForSelectedDate = allTasks.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
}
