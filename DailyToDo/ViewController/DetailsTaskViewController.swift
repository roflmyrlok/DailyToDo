//
//  DetailsTaskViewController.swift
//  DailyToDo
//
//  Created by Andrii Trybushnyi on 18.12.2024.
//

import UIKit

class DetailsTaskViewController: UIViewController {
    private var task: Task
    private let onTaskUpdated: (Task) -> Void
    private var timer: Timer?

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var deleteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemRed
        configuration.title = "Delete Task"
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var completeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemGreen
        configuration.title = "Complete"
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    init(task: Task, onTaskUpdated: @escaping (Task) -> Void) {
        self.task = task
        self.onTaskUpdated = onTaskUpdated
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureTaskDetails()
        startTimer()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Task Details"
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(statusLabel)
        view.addSubview(timeRemainingLabel)
        view.addSubview(deleteButton)
        view.addSubview(completeButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
                descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

                timeRemainingLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                timeRemainingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                timeRemainingLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                statusLabel.topAnchor.constraint(equalTo: timeRemainingLabel.bottomAnchor, constant: 16),
                statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

                deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                deleteButton.widthAnchor.constraint(equalToConstant: 150),
                deleteButton.heightAnchor.constraint(equalToConstant: 50),

                completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                completeButton.widthAnchor.constraint(equalToConstant: 150),
                completeButton.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
    }

    private func configureTaskDetails() {
        nameLabel.text = task.name
        descriptionLabel.text = task.description
        updateTimeRemainingLabel()
        updateStatusLabel()
        updateCompleteButtonTitle()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 60,
            target: self,
            selector: #selector(updateTimeRemainingLabel),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        stopTimer()
    }

    @objc private func updateTimeRemainingLabel() {
        guard let deadline = task.deadline else {
            timeRemainingLabel.text = "No deadline set"
            timeRemainingLabel.textColor = .label
            return
        }

        let now = Date()
        let timeRemaining = deadline.timeIntervalSince(now)

        if timeRemaining <= 0 {
            timeRemainingLabel.text = "Deadline passed"
            timeRemainingLabel.textColor = .systemRed
        } else {
            let hours = Int(timeRemaining) / 3600
            let minutes = (Int(timeRemaining) % 3600) / 60
            timeRemainingLabel.text = "Time Remaining: \(hours)h \(minutes)m"
            timeRemainingLabel.textColor = hours <= 1 ? .systemRed : .label
        }
    }

    private func updateStatusLabel() {
        statusLabel.text = task.done ? "Status: Completed" : "Status: In Progress"
        statusLabel.textColor = task.done ? .secondaryLabel : .label
    }

    private func updateCompleteButtonTitle() {
        completeButton.configuration?.title = task.done ? "Incomplete" : "Complete"
        completeButton.configuration?.baseBackgroundColor = task.done ? .systemOrange : .systemGreen
    }

    @objc private func deleteButtonTapped() {
        let alertController = UIAlertController(
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                TaskManager.shared.deleteTask(self.task)
                self.onTaskUpdated(self.task)
                self.dismiss(animated: true)
            }
        )
        present(alertController, animated: true)
    }

    @objc private func completeButtonTapped() {
        task.done.toggle()
        TaskManager.shared.updateTask(task)
        updateStatusLabel()
        updateCompleteButtonTitle()
        onTaskUpdated(task)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
