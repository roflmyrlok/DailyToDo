//
//  DailyToDoUITests.swift
//  DailyToDoUITests
//
//  Created by Andrii Trybushnyi on 16.12.2024.
//

import XCTest

final class DailyToDoUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testCreateNewTaskButtonExists() throws {
        let createTaskButton = app.buttons["Create New Task"]
        XCTAssertTrue(createTaskButton.exists, "Create New Task button should be visible on the screen")
    }

    func testEmptyStateHidesWhenTasksArePresent() throws {

        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "TableView should be visible when there are tasks")
        
        let emptyStateLabel = app.staticTexts["You have no tasks"]
        XCTAssertFalse(emptyStateLabel.exists, "Empty state label should be hidden when there are tasks")
    }

    func testTaskListShowsCorrectNumberOfTasks() throws {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "TableView should be visible")

        let cellCount = tableView.cells.count
        XCTAssertGreaterThan(cellCount, 0, "TableView should have at least one task")
    }
}
