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
    var topStack: UIStackView = UIStackView()
    var bottomStack: UIStackView = UIStackView()

    var more = UIButton()
    var row: Int?
    var blocked = StatusButton()

    func setup(){
        
        more.setTitle("More >", for: .normal)
        
        //more.backgroundColor = .gray
        more.setTitleColor(.black, for: .normal)
        more.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        blocked.translatesAutoresizingMaskIntoConstraints = false

        blocked.setTitle("blocked", for: .normal)
        blocked.widthAnchor.constraint(equalToConstant: 100).isActive = true

        blocked.backgroundColor = .red
        blocked.addTarget(self, action: #selector(blockedSwitch), for: .touchUpInside)

        
        topStack.addArrangedSubview(blocked)
        topStack.addArrangedSubview(view)
        topStack.distribution = .fillProportionally

        bottomStack.addArrangedSubview(UIView())

        bottomStack.addArrangedSubview(more)

        stack.addArrangedSubview(topStack)
        stack.addArrangedSubview(bottomStack)

        stack.axis = .vertical
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

