//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by Sean Donato on 9/13/24.
//

import Foundation
import UIKit
class AddListItemViewController: UIViewController{
    
//    let closeButton
    let viewModel: ToDoListViewModel
    var titleLabel: UILabel = UILabel()
    var entryLabel: UILabel = UILabel()
    var entryField: UITextField = UITextField()
    var addButton: TDLButton = TDLButton()
    
    init(_ viewModel: ToDoListViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AddItemViewController{
    
        func setup(){
            
            self.view.backgroundColor = .white
            self.view.addSubview(titleLabel)
            self.view.addSubview(entryLabel)
            self.view.addSubview(entryField)
            self.view.addSubview(addButton)
            
            //new
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            entryLabel.translatesAutoresizingMaskIntoConstraints = false
            entryField.translatesAutoresizingMaskIntoConstraints = false
            addButton.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.text = "To Do List"
            titleLabel.font = .boldSystemFont(ofSize: 14)
            addButton.setTitle("Add Item", for: .normal)
            entryLabel.text = "Item:"
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

            NSLayoutConstraint.activate([
                addButton.leadingAnchor.constraint(equalTo: entryField.trailingAnchor,constant:50),
                addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -16),
                addButton.centerYAnchor.constraint(equalTo: entryField.centerYAnchor,constant:0),
                addButton.heightAnchor.constraint(equalToConstant: 44),
                addButton.widthAnchor.constraint(equalToConstant: 44)
            ])
            
            addButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)

        }
        
    }
extension AddListItemViewController{
    @objc func saveItem(){
        if let name = entryField.text{
            //TODO save item
           // viewModel.saveTask(name)
            viewModel.saveItem(name)
            self.dismiss(animated: true)
        }
    }
}

