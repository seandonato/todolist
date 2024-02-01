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
}
class TaskDetailViewController: UIViewController,StatusPickerDelegate{
    func changeStatus(status: TaskStatus) {
        CoreDataManager().updateTaskStatus(self.task, status)
    }
    
    
    let task : Task
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        let statusPicker = StatusPicker()
        self.view.addSubview(statusPicker)
        statusPicker.translatesAutoresizingMaskIntoConstraints = false
        statusPicker.delegate = self
        NSLayoutConstraint.activate([
            statusPicker.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100),
            statusPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            statusPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
            statusPicker.heightAnchor.constraint(equalToConstant: 200)

        ])
    }
}
