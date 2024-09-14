//
//  TaskDetailViewControllerAlpha.swift
//  ToDoList
//
//  Created by Sean Donato on 9/3/24.
//

import Foundation
import UIKit


class TaskDetailViewControllerAlpha: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.toDoTask.items?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < items.count{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as? ItemTableViewCell{
                if let items = viewModel.toDoTask.items{
                    cell.setup()

                    cell.titleLabel.text = items[indexPath.row].name
                    return cell

                }
            }

        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "addItem", for: indexPath) as? AddItemCell{
                cell.setup()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    var rows = 0
    
    //tableview with items cells, add item cell, notes cells, add note cell
    let viewModel: TaskDetailVCViewModel
    var textView = UITextView()
    let titleLabel = UILabel()
    let saveButton = TDLButton()
    var keyboardDismissView = UIView()
    var tableView: UITableView = UITableView()
    
    init(_ viewModel: TaskDetailVCViewModel) {
        self.viewModel = viewModel
        if let items = viewModel.toDoTask.items{
            self.items = items

        }
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = viewModel.toDoTask.name
        saveButton.setTitle("save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var items = [ToDoItem]()

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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(AddItemCell.self, forCellReuseIdentifier: "addItem")
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "item")
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: statusSwitcher.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
//        self.view.addSubview(textView)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            textView.topAnchor.constraint(equalTo: statusSwitcher.bottomAnchor,constant: 26),
//            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 16),
//            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
//            textView.heightAnchor.constraint(equalToConstant: 350)
//
//        ])
//        textView.text = viewModel.toDoTask.note
//        textView.layer.borderWidth = 0.5
//        textView.layer.borderColor = UIColor(named: "Border")?.cgColor
//        textView.font = .systemFont(ofSize: 16)
//        self.view.addSubview(saveButton)
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor,constant: 12),
//            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
//            saveButton.widthAnchor.constraint(equalToConstant: 75)
//
//        ])

//        self.view.addSubview(keyboardDismissView)
//        keyboardDismissView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            keyboardDismissView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 12),
//            keyboardDismissView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
//            keyboardDismissView.leadingAnchor.constraint(equalTo: statusSwitcher.trailingAnchor,constant: 8),
//            keyboardDismissView.bottomAnchor.constraint(equalTo: textView.topAnchor,constant: 8)
//        ])
//        
//        let tapGesture = UITapGestureRecognizer()
//        tapGesture.addTarget(self, action: #selector(dismissKB))
//        keyboardDismissView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKB(){
        textView.endEditing(true)
    }
    @objc func saveNote(){
        viewModel.saveNote(viewModel.toDoTask, textView.text)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == items.count {
            self.addItem()
        }
    }
}
extension TaskDetailViewControllerAlpha: AddItemDelegate{
    func addItem() {
        let vc = AddItemViewController(self.viewModel)
        self.present(vc, animated: true)
    }

}
