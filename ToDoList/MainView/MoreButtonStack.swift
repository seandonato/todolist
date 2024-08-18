//
//  MoreButtonStack.swift
//  ToDoList
//
//  Created by Sean Donato on 8/14/24.
//

import Foundation
//
//  StatusButtonStack.swift
//  ToDoList
//
//  Created by Sean Donato on 8/13/24.
//

import Foundation
import UIKit

class MoreButtonStack: UIView{
    
    weak var statusDelegate: StatusUISwitcher?

    weak var delegate: TaskCellDelegate?
    var stack: UIStackView = UIStackView()
    var more = StatusButton()
    var row: Int?
    var blocked = StatusButton()

    func setup(){
        
        more.setTitle("More >", for: .normal)
        
        more.backgroundColor = .blue
        more.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        blocked.setTitle("blocked", for: .normal)
        blocked.backgroundColor = .red
        blocked.addTarget(self, action: #selector(blockedSwitch), for: .touchUpInside)

        stack.addArrangedSubview(blocked)

        stack.addArrangedSubview(view)
        stack.addArrangedSubview(more)

        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func showDetail(){
        if let row = row{
            delegate?.showDetailView(row)
        }
    }
    
    @objc func blockedSwitch(){
        statusDelegate?.changeStatusFor(.blocked)
    }

}

