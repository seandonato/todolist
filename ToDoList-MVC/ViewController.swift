//
//  ViewController.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TaskTableViewCell{
            
            let task = tasks[indexPath.row]
            cell.titleLabel.text = task.name
            cell.statusLabel.text = task.status
            if task.status == "ready"{
                cell.statusLabel.backgroundColor = .green

            }else if task.status == "done"{
                cell.statusLabel.backgroundColor = .blue

            }else if task.status == "blocked"{
                cell.statusLabel.backgroundColor = .red

            }
     
            
            // *********** EDIT ***********
           // let editAction = UIContextualAction(style: .normal, title: "Edit") {
//                (action, sourceView, completionHandler) in
//
//                let food = self.foodItems[(indexPath as NSIndexPath).row] as FoodItem
//                self.presenter?.didSelectItemToEdit(food)
//                // 1. Segue to Edit view MUST PASS INDEX PATH as Sender to the prepareSegue function
//                //self.performSegue(withIdentifier: "showBookEdit", sender: indexPath) // sender = indexPath
//                completionHandler(true)
                
           // }
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            let t = self.tasks[(indexPath as NSIndexPath).row] as Task
            self.deleteTask(name: t.name)
            // Delete the book and associated records
            //self.swipeDeleteAction(book: book, indexPath: indexPath)
            // Remove the menu option from the screen
            completionHandler(true)
        } // end action Delete
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeConfiguration
    }
    
    var tasks = [Task]()
    var titleLabel = UILabel()
    var entryLabel = UILabel()
    var tableView = UITableView()
    var entryField = UITextField()
    var addButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        getTasks()
    }
    func setup(){
        self.view.addSubview(titleLabel)
        self.view.addSubview(entryLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(entryField)
        self.view.addSubview(addButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        entryLabel.translatesAutoresizingMaskIntoConstraints = false
        entryField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        
        titleLabel.text = "To Do List"
        addButton.setTitle("+", for: .normal)
        addButton.backgroundColor = .blue
        entryLabel.text = "Task:"
        entryField.borderStyle = .line
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor,constant:50),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            entryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant:16),
            entryLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            entryLabel.trailingAnchor.constraint(equalTo: self.view.centerXAnchor,constant: -8),
            entryLabel.widthAnchor.constraint(equalToConstant: 200)

        ])
        NSLayoutConstraint.activate([
            entryField.topAnchor.constraint(equalTo: entryLabel.bottomAnchor,constant:16),
            entryField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            entryField.trailingAnchor.constraint(equalTo: entryLabel.trailingAnchor,constant: 0)

        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: entryField.trailingAnchor,constant:50),
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
            addButton.centerYAnchor.constraint(equalTo: entryField.centerYAnchor,constant:0),

            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44)

        ])
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
    }
    
    @objc func saveTask(){
        let coreDataManager = CoreDataManager()
        let uuid = UUID()
        var task = Task(name: entryField.text ?? "", uuid: uuid, status: "ready")
        coreDataManager.saveTask(task)
        entryField.text = ""
        getTasks()
    }
    
    func getTasks(){
        let coreDataManager = CoreDataManager()
        
        if let tasks = coreDataManager.getTasks(){
            self.tasks = tasks
        }
        tableView.reloadData()
    }
    func deleteTask(name: String){
        let tasks = tasks.filter { task in
            return task.name != name
        }
    }
}

