//
//  HomeVM.swift
//  Reminder
//
//  Created by Sami Gündoğan on 28.04.2025.
//

import Foundation

protocol HomeVMProtocol {
    var greetingText: String { get }
    var availableDates: [Date] { get }
    var selectedDate: Date? { get set }
    var tasksForSelectedDate: [Task] { get }
    
    func updateTask(_ task: Task)
    func loadAvailableDates(for numberOfDays: Int)
    func updateSelectedDate(at index: Int)
    func loadTasksFromStorage()
    func addNewTask(_ task: Task)
    func deleteTask(with id: UUID)
}

final class HomeVM: HomeVMProtocol {
    
    // MARK: - Dependencies
    
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
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good Morning!"
        case 12..<17: return "Good Afternoon!"
        case 17..<21: return "Good Evening!"
        default: return "Good Night!"
        }
    }
    
    // MARK: - Public Methods
    
    func loadAvailableDates(for numberOfDays: Int) {
        let calendar = Calendar.current
        let today = Date()
        availableDates = (0..<numberOfDays).compactMap {
            calendar.date(byAdding: .day, value: $0, to: today)
        }
    }
    
    func updateSelectedDate(at index: Int) {
        guard availableDates.indices.contains(index) else { return }
        selectedDate = availableDates[index]
    }
    
    func loadTasksFromStorage() {
        allTasks = storageService.retrieve()
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
