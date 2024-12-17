//
//  ViewController.swift
//  DailyToDo
//
//  Created by Andrii Trybushnyi on 16.12.2024.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        return table
    }()

    private lazy var createTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create New Task", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createTaskTapped), for: .touchUpInside)
        return button
    }()

    private var tasks: [Task] = []
    private let firstLaunchKey = "isFirstLaunch"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        checkFirstLaunch()
        loadTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Daily Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        view.addSubview(createTaskButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: createTaskButton.topAnchor, constant: -16),

            createTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createTaskButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func checkFirstLaunch() {
        let defaults = UserDefaults.standard
        let isFirstLaunch = !defaults.bool(forKey: firstLaunchKey)

        if isFirstLaunch {
            createExampleTasks()
            defaults.set(true, forKey: firstLaunchKey)
        }
    }

    private func createExampleTasks() {
        let exampleTasks = [
            Task(name: "Clean Apartment", description: "Vacuum and do laundry", done: true),
            Task(name: "Buy Groceries", description: "Milk, bread, eggs, and vegetables"),
            Task(name: "Workout", description: "30 minutes of cardio at the gym"),
            Task(name: "Read a Book", description: "Finish the first chapter of the new novel"),
            Task(name: "Plan Weekend Trip", description: "Research destinations and book accommodation")
        ]

        exampleTasks.forEach { TaskManager.shared.addTask($0) }
    }

    private func loadTasks() {
        tasks = TaskManager.shared.loadTasks()
        tableView.reloadData()
    }

    @objc private func createTaskTapped() {
        // TODO: Implement navigation to create task screen
        print("Create Task button tapped")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]

        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.description

        let detailsButton = UIButton(type: .detailDisclosure)
        detailsButton.tag = indexPath.row
        detailsButton.addTarget(self, action: #selector(showTaskDetails(_:)), for: .touchUpInside)
        cell.accessoryView = detailsButton

        cell.textLabel?.textColor = task.done ? .secondaryLabel : .label

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToRemove = tasks[indexPath.row]
            TaskManager.shared.deleteTask(taskToRemove)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @objc private func showTaskDetails(_ sender: UIButton) {
        let selectedTask = tasks[sender.tag]
        // TODO: Implement navigation to task details screen
        print("Show details for task: \(selectedTask.name)")
    }
}
