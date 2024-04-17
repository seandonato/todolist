//
//  GroupListViewController.swift
//  ToDoList
//
//  Created by Sean Donato on 4/17/24.
//

import Foundation
import UIKit

class GroupListViewController : UIViewController{
    let titleLabel: UILabel = UILabel()
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI(){
        titleLabel.text = "Groups"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 50)
        ])
    }
}
