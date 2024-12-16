//
//  DailyToDoTests.swift
//  DailyToDoTests
//
//  Created by Andrii Trybushnyi on 16.12.2024.
//

import XCTest
@testable import DailyToDo

final class DailyToDoTests: XCTestCase {

    // Test Task Initialization
    func testTaskInitialization() {
        let task = Task(name: "Test Task", description: "A simple test task.")
        XCTAssertNotNil(task.id, "Task ID should not be nil.")
        XCTAssertEqual(task.name, "Test Task", "Task name should match the initialization value.")
        XCTAssertEqual(task.description, "A simple test task.", "Task description should match the initialization value.")
        XCTAssertEqual(task.done, false, "Task 'done' status should default to false.")
    }

    // Test Saving and Loading Tasks
    func testSaveAndLoadTasks() {
        let taskManager = TaskManager.shared
        let tasks = [
            Task(name: "Task 1", description: "Description 1"),
            Task(name: "Task 2", description: "Description 2")
        ]
        
        taskManager.saveTasks(tasks)
        let loadedTasks = taskManager.loadTasks()

        XCTAssertEqual(loadedTasks.count, tasks.count, "The number of loaded tasks should match the number of saved tasks.")
        XCTAssertEqual(loadedTasks[0].name, tasks[0].name, "The first task's name should match.")
        XCTAssertEqual(loadedTasks[1].description, tasks[1].description, "The second task's description should match.")
    }

    // Test Adding a Task
    func testAddTask() {
        let taskManager = TaskManager.shared
        taskManager.saveTasks([]) // Start with an empty task list
        
        let task = Task(name: "New Task", description: "A new test task.")
        taskManager.addTask(task)
        
        let loadedTasks = taskManager.loadTasks()
        XCTAssertEqual(loadedTasks.count, 1, "There should be exactly one task after adding a task.")
        XCTAssertEqual(loadedTasks[0].name, task.name, "The added task's name should match.")
    }

    // Test Updating a Task
    func testUpdateTask() {
        let taskManager = TaskManager.shared
        let task = Task(name: "Original Task", description: "Original description.")
        taskManager.saveTasks([task])
        
        var updatedTask = task
        updatedTask.name = "Updated Task"
        updatedTask.description = "Updated description."
        updatedTask.done = true
        
        taskManager.updateTask(updatedTask)
        let loadedTasks = taskManager.loadTasks()
        
        XCTAssertEqual(loadedTasks.count, 1, "There should still be exactly one task after updating.")
        XCTAssertEqual(loadedTasks[0].name, "Updated Task", "The task's name should be updated.")
        XCTAssertEqual(loadedTasks[0].description, "Updated description.", "The task's description should be updated.")
        XCTAssertEqual(loadedTasks[0].done, true, "The task's done status should be updated.")
    }

    // Test Deleting a Task
    func testDeleteTask() {
        let taskManager = TaskManager.shared
        let task1 = Task(name: "Task 1", description: "Description 1")
        let task2 = Task(name: "Task 2", description: "Description 2")
        taskManager.saveTasks([task1, task2])

        taskManager.deleteTask(task1)
        let loadedTasks = taskManager.loadTasks()

        XCTAssertEqual(loadedTasks.count, 1, "There should be one task left after deleting one.")
        XCTAssertEqual(loadedTasks[0].name, task2.name, "The remaining task's name should match the undeleted task.")
    }

    // Test Empty Task Loading
    func testLoadEmptyTasks() {
        let taskManager = TaskManager.shared
        taskManager.saveTasks([]) // Save an empty task list

        let loadedTasks = taskManager.loadTasks()
        XCTAssertTrue(loadedTasks.isEmpty, "Loading tasks from an empty list should result in an empty array.")
    }
}
