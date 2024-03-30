//
//  ViewController.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import UIKit

class ToDoListViewController: UIViewController,UITextFieldDelegate, ToDoListViewModelDelegate{
    
    func didFinishFetchingData() {
        entryField.text = ""
        tableView.reloadData()
    }

    let viewModel: ToDoListViewModel
    var titleLabel: UILabel = UILabel()
    var entryLabel: UILabel = UILabel()
    var tableView: UITableView = UITableView()
    var entryField: UITextField = UITextField()
    var addButton: TDLButton = TDLButton()
    
    init(_ viewModel: ToDoListViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.toDoListViewModelDelegate = self
        setup()
    }
            
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
}

extension ToDoListViewController{
    func setup(){
        
        self.view.backgroundColor = .white
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
        titleLabel.font = .boldSystemFont(ofSize: 14)
        addButton.setTitle("Add Task", for: .normal)
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        addButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
    }
}

extension ToDoListViewController{
    @objc func saveTask(){
        if let name = entryField.text{
            viewModel.saveTask(name)
        }
    }
}

extension ToDoListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = viewModel.tasks?[indexPath.row] else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TaskTableViewCell{
            cell.viewModel = viewModel
            cell.taskDelegate = self
            cell.toDoTask = task
            cell.setup()
            cell.row = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
    
}

extension ToDoListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks?.count ?? 0
    }
    
}

extension ToDoListViewController: TaskCellDelegate{
    
    func showDetailView(_ row: Int) {
        guard let task = viewModel.tasks?[row] else {return}
        let viewModel = TaskDetailVCViewModel(toDoTask: task, coreDataManager: viewModel.coreDataManager)
        let taskDetailView = TaskDetailViewController(viewModel)
        self.navigationController?.pushViewController(taskDetailView, animated: true)

    }
    
}


