//
//  TaskDetailViewControllerAlpha.swift
//  ToDoList
//
//  Created by Sean Donato on 9/3/24.
//

import Foundation
import UIKit


class TaskDetailViewControllerAlpha: UIViewController,UITextViewDelegate{
    
    let viewModel: TaskDetailVCViewModel
    var textView = UITextView()
    let titleLabel = UILabel()
    let saveButton = TDLButton()
    var keyboardDismissView = UIView()
    
    init(_ viewModel: TaskDetailVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = viewModel.toDoTask.name
        saveButton.setTitle("save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor(named: "Background")

        let statusSwitcher = StatusSwitcher(frame: CGRect(x: 0, y: 0, width: 100, height: 36), viewModel.toDoTask.taskStatus ?? .ready)
        statusSwitcher.delegate = viewModel
        statusSwitcher.toDoTask = viewModel.toDoTask
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusSwitcher.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(statusSwitcher)
        if let t = viewModel.toDoTask.taskStatus{
            statusSwitcher.cycleStatusNoAnimation(t)
        }

        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.widthAnchor.constraint(equalToConstant: 100)

        ])
        NSLayoutConstraint.activate([
            statusSwitcher.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 16),
            statusSwitcher.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            statusSwitcher.heightAnchor.constraint(equalToConstant: 36),
            statusSwitcher.widthAnchor.constraint(equalToConstant: 100)

        ])
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: statusSwitcher.bottomAnchor,constant: 26),
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 350)

        ])
        textView.text = viewModel.toDoTask.note
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(named: "Border")?.cgColor
        textView.font = .systemFont(ofSize: 16)
        self.view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor,constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 75)

        ])

        self.view.addSubview(keyboardDismissView)
        keyboardDismissView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardDismissView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 12),
            keyboardDismissView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
            keyboardDismissView.leadingAnchor.constraint(equalTo: statusSwitcher.trailingAnchor,constant: 8),
            keyboardDismissView.bottomAnchor.constraint(equalTo: textView.topAnchor,constant: 8)
        ])
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(dismissKB))
        keyboardDismissView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKB(){
        textView.endEditing(true)
    }
    @objc func saveNote(){
        viewModel.saveNote(viewModel.toDoTask, textView.text)
    }
}
