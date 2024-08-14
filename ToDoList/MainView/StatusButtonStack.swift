//
//  StatusButtonStack.swift
//  ToDoList
//
//  Created by Sean Donato on 8/13/24.
//

import Foundation
import UIKit


class StatusButtonStack: UIView{
    
    var stack: UIStackView = UIStackView()
    
    func setup(){
        
        var ready = UIButton()
        ready.setTitle("ready", for: .normal)
        ready.backgroundColor = .green
        
        var inProgress = UIButton()
        inProgress.setTitle("in progress", for: .normal)
        inProgress.backgroundColor = .purple
        
        stack.addArrangedSubview(ready)
        stack.addArrangedSubview(inProgress)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}

