//
//  ListViewControllerAlpha.swift
//  ToDoList
//
//  Created by Sean Donato on 9/25/24.
//

import Foundation
import UIKit

class ListViewControllerAlpha: UIViewController, UITableViewDelegate, UITableViewDataSource,AddTaskDelegate,TaskGroupViewModelDelegate{
    func didFinishFetchingData() {
        if let lists = viewModel.lists{
            self.lists = lists
            self.tableView.reloadData()

        }
    }
    
    func addTask() {
        let vc = AddListViewController(viewModel)
        self.present(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == lists.count {
            let cell = AddTaskCell()
            cell.titleLabel.text = "+ Add Task"
            cell.delegate = self
            return cell
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell{
                
                cell.titleLabel.text = lists[indexPath.row].name
                //cell.setup()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    var tableView: UITableView = UITableView()
//    let viewModel: ToDoListViewModel 
    let viewModel: ListViewModel

    var lists: [ToDoTask]
    let selectedIndex: Int
    let titleLabel: UILabel = UILabel()
    
    init(_ viewModel:ListViewModel,_ lists: [ToDoTask],_ selectedIndex: Int) {
        self.lists = lists
        self.selectedIndex = selectedIndex
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
        self.viewModel.fetchLists()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupUI(){
        titleLabel.text = viewModel.group?.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        tableView.allowsSelection = true

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                viewModel.deleteList(lists[indexPath.row].uuid)
            }
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < lists.count{
          //  if let list = lists[indexPath.row]{
                navigateToToDoList(list: lists[indexPath.row])

           // }
        }
        newList(list: lists[indexPath.row])
        
    }
    func backToTaskList(){
        
    }
    func newList(list:ToDoTask){
//        viewModel.setList(list: list)
//        viewModel.fetchData()
    }
    func navigateToToDoList(list:ToDoTask){
        if #available(iOS 17.0, *) {
            let toDoListViewModel = ToDoListViewModelObservable()
            if let persistantCon = self.viewModel.coreDataManager?.persistentContainer{
                var coreDataMan = CoreDataManager(persistentContainer: persistantCon)
                toDoListViewModel.toDoTask = coreDataMan.getList2(listID: list.uuid)

                toDoListViewModel.coreDataManager = coreDataMan

    //           old self.navigationController?.pushViewController(ToDoListViewController(toDoListViewModel), animated: true)
                //new with hosting
                self.navigationController?.pushViewController(TaskListHostingController(viewModel: toDoListViewModel), animated: true)
                
                
                
        } else {
            // Fallback on earlier versions
        }

        }

    }
}
