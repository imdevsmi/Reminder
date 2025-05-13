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
    
    // MARK: - Public Properties
    
    var onTasksUpdated: (() -> Void)?
    
    private(set) var availableDates: [Date] = []
    private(set) var tasksForSelectedDate: [Task] = []
    
    var selectedDate: Date? {
        didSet { filterTasksForSelectedDate() }
    }

    var greetingText: String {
        let name = UserDefaults.standard.string(forKey: "") ?? "Sami"
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12: return "Good Morning \(name)"
        case 12..<17: return "Good Afternoon \(name)"
        case 17..<21: return "Good Evening \(name)"
        default: return "Good Night \(name)"
        }
    }
    
    // MARK: - Private Properties

    private var allTasks: [Task] = [] {
        didSet { filterTasksForSelectedDate() }
    }
    
    private let storageService = TaskStorageService()
    
    // MARK: - Public Methods
    
    func loadAvailableDates(for numberOfDays: Int) {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        
        availableDates = (0..<(numberOfDays + 3)).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startDate)
        }
    }

    func updateSelectedDate(at index: Int) {
        guard availableDates.indices.contains(index) else { return }
        selectedDate = availableDates[index]
    }

    func loadTasksFromStorage() {
        allTasks = storageService.retrieve()
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

    // MARK: - Private Methods
    
    private func filterTasksForSelectedDate() {
        guard let selectedDate else {
            tasksForSelectedDate = []
            return
        }
        
        tasksForSelectedDate = allTasks.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
}
