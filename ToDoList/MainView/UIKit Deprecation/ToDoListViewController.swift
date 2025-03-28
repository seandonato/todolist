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
        titleLabel.text = viewModel.list?.name
        tableView.reloadData()
    }

    let viewModel: ToDoListViewModel
    var titleLabel: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    var entryLabel: UILabel = UILabel()
    var tableView: UITableView = UITableView()
    var entryField: UITextField = UITextField()
    var addButton: TDLButton = TDLButton()
    var expandedRow: Int?
    
    //new for group
    //var groupSwitchButton: TDLButton = TDLButton()

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
        self.view.addSubview(dateLabel)
        self.view.addSubview(tableView)
//        self.view.addSubview(entryField)
//        self.view.addSubview(addButton)


        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        entryField.translatesAutoresizingMaskIntoConstraints = false
//        addButton.translatesAutoresizingMaskIntoConstraints = false


        titleLabel.text = viewModel.list?.name
        dateLabel.text = viewModel.list?.date.description

        titleLabel.font = .boldSystemFont(ofSize: 24)
        addButton.setTitle("Add Task", for: .normal)
        entryLabel.text = "Task:"
        entryField.borderStyle = .line
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor,constant:100),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant:12),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16)

            
        ])
//        NSLayoutConstraint.activate([
//            entryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant:16),
//            entryLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
//            entryLabel.trailingAnchor.constraint(equalTo: self.view.centerXAnchor,constant: -8),
//            entryLabel.widthAnchor.constraint(equalToConstant: 200)
//        ])
//        
//        NSLayoutConstraint.activate([
//            entryField.topAnchor.constraint(equalTo: entryLabel.bottomAnchor,constant:16),
//            entryField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
//            entryField.trailingAnchor.constraint(equalTo: entryLabel.trailingAnchor,constant: 0)
//
//        ])
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            addButton.leadingAnchor.constraint(equalTo: entryField.trailingAnchor,constant:50),
//            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
//            addButton.centerYAnchor.constraint(equalTo: entryField.centerYAnchor,constant:0),
//            addButton.heightAnchor.constraint(equalToConstant: 44),
//            addButton.widthAnchor.constraint(equalToConstant: 44)
//        ])

        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TaskTableViewCellAlpha.self, forCellReuseIdentifier: "cella")
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "itemCell2")
        tableView.register(ItemListCell.self, forCellReuseIdentifier: "itemCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        addButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
    }
    
    @objc func presentListViewController(){
        let vc = GroupListViewController(viewModel, viewModel.lists ?? [], 0)
        present(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Sub Tasks"
        }else{
            return "Items"
        }
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
        print(indexPath.row)
        if indexPath.section == 0{
            if indexPath.row == viewModel.tasks?.count ?? 0{
                let cell = AddTaskCell()
                cell.titleLabel.text = "+ Add Sub Task"
                cell.delegate = self
                return cell
            }
            guard let task = viewModel.tasks?[indexPath.row] else {
                return UITableViewCell()
            }

            if let cell = tableView.dequeueReusableCell(withIdentifier: "cella") as? TaskTableViewCellAlpha{
                cell.viewModel = viewModel
                cell.taskDelegate = self
                cell.toDoTask = task
                cell.expanded = expandedRow == indexPath.row ? true : false
                cell.setup()
                cell.row = indexPath.row
                return cell
            }
        }else if indexPath.section == 1{
            if indexPath.row == viewModel.items?.count ?? 0{
                let cell = AddItemCell()
                cell.titleLabel.text = "+ Add Item"
                cell.delegate = self
                return cell
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemListCell{
//                cell.viewModel = viewModel
//                cell.taskDelegate = self
//                cell.toDoTask = task
                //cell.expanded = expandedRow == indexPath.row ? true : false
                //cell.setup()
                if let item = viewModel.items?[indexPath.row]{
                    cell.titleLabel.text = item.name
                    cell.row = indexPath.row
                    cell.checked = false

                    cell.delegate = self
                    return cell
                }
                return cell
            }
        }
        
        
        
        return UITableViewCell()
    }
}

extension ToDoListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

          if indexPath.section == 0{
              if let task = viewModel.tasks?[indexPath.row]{
                  self.viewModel.deleteTask(task)
                  viewModel.fetchData()
              }
          }else if indexPath.section == 1{
              if let item = viewModel.items?[indexPath.row]{
                  self.viewModel.deleteItem(item)
                  viewModel.fetchData()
              }
          }
      }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if let cellModel = viewModel.tasks?[indexPath.row]{
                
                tableView.beginUpdates()
                viewModel.tasks?[indexPath.row].expanded.toggle()
                if viewModel.tasks?[indexPath.row].expanded == true{
                    self.expandedRow = indexPath.row
                }else{
                    self.expandedRow = nil

                }
                 tableView.reloadRows(at: [indexPath], with: .automatic)

                // tableView.reloadData()
                tableView.endUpdates()
            }

        }
        if indexPath.section == 1{
            if indexPath.row == viewModel.items?.count{
                addItem()
            }
        }
//        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCellAlpha{
//            if cell.expanded == false{
//                cell.expanded? = true
//            }else{
//                cell.expanded? = false
//
//            }
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//
//        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
          return  (viewModel.tasks?.count ?? 0) + 1
        }else if section == 1{
            return  (viewModel.items?.count ?? 0) + 1

        }
        return 0
    }
    
}

extension ToDoListViewController: TaskCellDelegate{
    
    func showDetailView(_ row: Int) {
        guard let task = viewModel.tasks?[row] else {return}
        let viewModel = TaskDetailVCViewModel(toDoTask: task, coreDataManager: viewModel.coreDataManager)
//        let taskDetailView = TaskDetailViewController(viewModel)
        let taskDetailView = TaskDetailViewControllerAlpha(viewModel)

        
        self.navigationController?.pushViewController(taskDetailView, animated: true)

    }
    
}

extension ToDoListViewController: AddTaskDelegate{
    func addTask() {
        let vc = AddTaskViewController(self.viewModel)
        self.present(vc, animated: true)
    }

}


extension ToDoListViewController: AddItemDelegate{
    func addItem() {
        let vc = AddListItemViewController(self.viewModel)
        self.present(vc, animated: true)
    }

}
extension ToDoListViewController: ItemAcquisitionDelegate{
    func acquiredItem(row: Int, acquired: Bool) {
        
    }
    
}


