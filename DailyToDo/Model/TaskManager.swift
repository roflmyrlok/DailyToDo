//
//  TaskManager.swift
//  DailyToDo
//
//  Created by Максим Поздняков on 16.12.2024.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    private init() {}

    private let userDefaults = UserDefaults.standard
    private let tasksKey = "tasks"

    func saveTasks(_ tasks: [Task]) {
        do {
            let encodedData = try JSONEncoder().encode(tasks)
            userDefaults.set(encodedData, forKey: tasksKey)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }

    func loadTasks() -> [Task] {
        guard let savedData = userDefaults.data(forKey: tasksKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Task].self, from: savedData)
        } catch {
            print("Error loading tasks: \(error)")
            return []
        }
    }

    func addTask(_ task: Task) {
        var tasks = loadTasks()
        tasks.append(task)
        saveTasks(tasks)
    }

    func updateTask(_ updatedTask: Task) {
        var tasks = loadTasks()
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            saveTasks(tasks)
        }
    }

    func deleteTask(_ task: Task) {
        var tasks = loadTasks()
        tasks.removeAll { $0.id == task.id }
        saveTasks(tasks)
    }
}
