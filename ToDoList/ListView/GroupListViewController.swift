//
//  GroupListViewController.swift
//  ToDoList
//
//  Created by Sean Donato on 4/17/24.
//

import Foundation
import UIKit

//list controller
class GroupListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource,AddTaskDelegate{
    func addTask() {
        //let vc = AddListViewController(viewModel)
       // self.present(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == lists.count {
            let cell = AddTaskCell()
            cell.titleLabel.text = "+ Add List"
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
    var okButton: TDLButton = TDLButton()
    let viewModel: ToDoListViewModel

    var lists: [ToDoTaskList]
    let selectedIndex: Int
    let titleLabel: UILabel = UILabel()
    
    init(_ viewModel:ToDoListViewModel,_ lists: [ToDoTaskList],_ selectedIndex: Int) {
        self.lists = lists
        self.selectedIndex = selectedIndex
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        titleLabel.text = "Task Groups"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 64),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle("OK", for: .normal)
        self.view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -64),
            okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -32),
            okButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 32)

        ])

        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: okButton.topAnchor)
        ])
        
        tableView.allowsSelection = true

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                lists.remove(at: indexPath.row)
                //TODO: delete list from core data
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .middle)
                tableView.endUpdates()
            }
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        newList(list: lists[indexPath.row])
        
    }
    func backToTaskList(){
        
    }
    func newList(list:ToDoTaskList){
        viewModel.setList(list: list)
        viewModel.fetchData()
        self.dismiss(animated: true)
    }
}
