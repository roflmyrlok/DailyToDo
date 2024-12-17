//
//  CreateTaskViewController.swift
//  DailyToDo
//
//  Created by Andrii Trybushnyi on 18.12.2024.
//

import UIKit

class CreateTaskViewController: UIViewController {

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Task", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        modalPresentationStyle = .fullScreen
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Create Task"
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            print("Please fill in all fields")
            return
        }

        let newTask = Task(name: name, description: description)
        TaskManager.shared.addTask(newTask)

        dismiss(animated: true, completion: nil) // Close the modal screen
    }

}
