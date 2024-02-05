//
//  TaskDetailViewController.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 1/30/24.
//

import Foundation
import UIKit

protocol StatusPickerDelegate: NSObject{
    func changeStatus(status:TaskStatus)
    func changeStatusFor(_ task:Task,status:TaskStatus)
    
}
class TaskDetailViewController: UIViewController,StatusPickerDelegate,UITextViewDelegate{
    func changeStatusFor(_ task:Task, status: TaskStatus) {
            CoreDataManager().updateTaskStatus(task, status){result in
                switch result{
                case .success(_):
                    return
                case .failure(_):
                    return
                }
            }
                 
    }
    

    func changeStatus(status: TaskStatus) {
        CoreDataManager().updateTaskStatus(task, status){result in
            switch result{
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
    
    weak var taskTabledelegate : TaskTableDelegate?
    var textView = UITextView()
    let task : Task
    let titleLabel = UILabel()
    let saveButton = TDLButton()
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = task.name
        saveButton.setTitle("save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white

        var statusSwitcher = StatusSwitcher(frame: CGRect(x: 0, y: 0, width: 100, height: 36), self.task.taskStatus ?? .ready)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusSwitcher.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(statusSwitcher)
        if let t = task.taskStatus{
            statusSwitcher.cycleStatusNoAnimation(t)
        }

        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.widthAnchor.constraint(equalToConstant: 100)

        ])
        statusSwitcher.delegate = self
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
        textView.text = task.note
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.gray.cgColor
        
        self.view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor,constant: 12),
            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 75)

        ])

    }
    
    @objc func saveNote(){
        CoreDataManager().updateTaskNotes(task, textView.text)
    }
}
