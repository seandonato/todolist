//
//  ListGroupViewController.swift
//  ToDoList
//
//  Created by Sean Donato on 9/21/24.
//

import Foundation
import UIKit

class GroupViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddEntityDelegate,ListGroupViewModelDelegate{
    func didFinishFetchingData() {
        if let vmGroups = viewModel.groups{
            self.groups = vmGroups
            tableView.reloadData()
        }
    }
    
    
    func addEntity() {
        let vc = AddGroupViewController (viewModel)
        self.present(vc, animated: true)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (groups?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == groups?.count ?? 0{
            let cell = AddEntityCell()
            cell.titleLabel.text = "+ Add Group"
            //cell.delegate = self
            return cell
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell{
                
                cell.titleLabel.text = groups?[indexPath.row].name
                //cell.setup()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    var tableView: UITableView = UITableView()

    let viewModel: ListGroupViewModel

    var groups: [ToDoListGroup]?
    let titleLabel: UILabel = UILabel()
    
    init(_ viewModel:ListGroupViewModel) {
        self.viewModel = viewModel
//        if let groups = viewModel.fetchGroups(){
//            self.groups = groups
//        }else{
//            groups = []
//        }
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.viewModel.fetchGroups()


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
        titleLabel.text = "Projects"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 64),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 32),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor)
        ])
        
        tableView.allowsSelection = true

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if (editingStyle == .delete) {
//                groups.remove(at: indexPath.row)
//                //TODO: delete list from core data
//                tableView.beginUpdates()
//                tableView.deleteRows(at: [indexPath], with: .middle)
//                tableView.endUpdates()
//            }
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == groups?.count ?? 0{
            newGroup()
        }else{
            if let group = viewModel.groups?[indexPath.row]{
                if let persistentContainer = self.viewModel.coreDataManager?.persistentContainer{
                    let listCoreDataManager = ListCoreDataManager(persistentContainer: persistentContainer)
                    let vm = ListViewModel(lists: [],coreDataManager: listCoreDataManager)
                    vm.group = group
                    if let lists = viewModel.groups?[indexPath.row].lists{
                        let vc = ListViewControllerAlpha(vm, lists, 0)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    func backToTaskList(){
        
    }
    
    func selectGroup(){
        //viewModel.setList(list: list)
        //viewModel.fetchData()
        //self.dismiss(animated: true)
    }

    func newGroup(){
        let vc = AddGroupViewController(viewModel)
        self.present(vc, animated: true)
       // viewModel.setList(list: list)
       // viewModel.fetchData()
        //self.dismiss(animated: true)
    }

}
