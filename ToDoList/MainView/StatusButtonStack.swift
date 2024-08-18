//
//  StatusButtonStack.swift
//  ToDoList
//
//  Created by Sean Donato on 8/13/24.
//

import Foundation
import UIKit

class StatusButton: UIButton{
    init() {
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = StyleTokens.buttonCornerRadius

        self.setTitle("", for: .normal)
        //self.titleLabel?.numberOfLines = 2
        self.titleEdgeInsets = UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 8)

        self.titleLabel?.font = StyleTokens.buttonFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class StatusButtonStack: UIView{
    
    weak var delegate: StatusUISwitcher?
    var stack: UIStackView = UIStackView()
    public var ready = StatusButton()
    public var inProgress = StatusButton()
    public var done = StatusButton()
    public var blocked = StatusButton()

    func setup(){
        
        ready.setTitle("ready", for: .normal)
        ready.backgroundColor = .green
        ready.addTarget(self, action: #selector(readySwitch), for: .touchUpInside)
        ready.translatesAutoresizingMaskIntoConstraints = false
        ready.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        inProgress.setTitle("in progress", for: .normal)
        inProgress.backgroundColor = .purple
        inProgress.addTarget(self, action: #selector(inProgressSwitch), for: .touchUpInside)
        inProgress.translatesAutoresizingMaskIntoConstraints = false

        inProgress.widthAnchor.constraint(equalToConstant: 140).isActive = true

        done.setTitle("done", for: .normal)
        done.backgroundColor = .blue
        done.addTarget(self, action: #selector(doneSwitch), for: .touchUpInside)
        done.translatesAutoresizingMaskIntoConstraints = false

        done.widthAnchor.constraint(equalToConstant: 100).isActive = true

        blocked.setTitle("blocked", for: .normal)
        blocked.backgroundColor = .red
        blocked.addTarget(self, action: #selector(blockedSwitch), for: .touchUpInside)

        stack.addArrangedSubview(ready)
        stack.addArrangedSubview(inProgress)
        stack.addArrangedSubview(done)
//        stack.addArrangedSubview(blocked)

        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.alignment = .center
        stack.distribution = .equalSpacing
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func readySwitch(){
        delegate?.changeStatusFor(.ready)
    }
    @objc func inProgressSwitch(){
        delegate?.changeStatusFor(.inProgress)
    }
    @objc func doneSwitch(){
        delegate?.changeStatusFor(.done)
    }
    @objc func blockedSwitch(){
        delegate?.changeStatusFor(.blocked)
    }
}

