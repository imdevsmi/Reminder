import Foundation

final class TaskStorageService {
    
    private let storageKey = "tasks"
    
    func store(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: storageKey)
        }
    }
    
    func retrieve() -> [Task] {
        let decoder = JSONDecoder()
        guard let savedData = UserDefaults.standard.data(forKey: storageKey),
              let decodedTasks = try? decoder.decode([Task].self, from: savedData) else {
            return []
        }
        return decodedTasks
    }
    
    func insert(_ task: Task) {
        var tasks = retrieve()
        tasks.append(task)
        store(tasks)
    }

    func update(_ updatedTask: Task) {
        var tasks = retrieve()
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            store(tasks)
        }
    }
    
    func deleteTask(with id: UUID) {
        var tasks = retrieve()
        tasks.removeAll { $0.id == id }
        store(tasks)
    }
}
