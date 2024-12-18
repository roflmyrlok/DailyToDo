//
//  Task.swift
//  DailyToDo
//
//  Created by Максим Поздняков on 16.12.2024.
//

import Foundation

struct Task: Codable {
    var id: UUID
    var name: String
    var description: String
    var done: Bool
    var timeEstimate: Int
    var deadline: Date?

    init(name: String, description: String, done: Bool = false, timeEstimate: Int = 0, deadline: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.done = done
        self.timeEstimate = timeEstimate
        self.deadline = deadline
    }
}
