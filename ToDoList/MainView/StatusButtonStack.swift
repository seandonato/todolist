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
    
    var topStack: UIStackView = UIStackView()
    var middleStack: UIStackView = UIStackView()
    var bottomStack: UIStackView = UIStackView()

    public var selectedStatus: ToDoTaskStatus?{
        didSet{
            if let status = selectedStatus{
                updateButtonColors(status)
            }
        }
    }
    weak var delegate: StatusUISwitcher?
    weak var taskDelegate: TaskCellDelegate?

    var stack: UIStackView = UIStackView()
    public var ready = StatusButton()
    public var inProgress = StatusButton()
    public var done = StatusButton()
    public var blocked = StatusButton()
    var more = UIButton()
    var row: Int?

    var width: CGFloat = 0.0
    var spaceAnchor: NSLayoutConstraint!
    var spacer = UIView()

    override func layoutSubviews() {
        
//        spaceAnchor.isActive = false
//        width = self.frame.width
//        spaceAnchor = spacer.widthAnchor.constraint(equalToConstant: self.width - 100)
//
//        spaceAnchor.isActive = true

    }
    func setup(){
        
        ready.setTitle("ready", for: .normal)
       // ready.backgroundColor = StyleTokens.re
        ready.addTarget(self, action: #selector(readySwitch), for: .touchUpInside)
        ready.translatesAutoresizingMaskIntoConstraints = false
        ready.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        inProgress.setTitle("in progress", for: .normal)
        //inProgress.backgroundColor = .purple
        inProgress.addTarget(self, action: #selector(inProgressSwitch), for: .touchUpInside)
        inProgress.translatesAutoresizingMaskIntoConstraints = false
        inProgress.widthAnchor.constraint(equalToConstant: 130).isActive = true

        done.setTitle("done", for: .normal)
        //done.backgroundColor = .blue
        done.addTarget(self, action: #selector(doneSwitch), for: .touchUpInside)
        done.translatesAutoresizingMaskIntoConstraints = false
        
        done.widthAnchor.constraint(equalToConstant: 80).isActive = true

        topStack.addArrangedSubview(ready)
        topStack.addArrangedSubview(inProgress)
        topStack.addArrangedSubview(done)
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.distribution = .equalCentering

        topStack.spacing = 6
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        blocked.translatesAutoresizingMaskIntoConstraints = false

        blocked.setTitle("blocked", for: .normal)
        blocked.widthAnchor.constraint(equalToConstant: 100).isActive = true

       // blocked.backgroundColor = .red
        blocked.addTarget(self, action: #selector(blockedSwitch), for: .touchUpInside)

        
        middleStack.addArrangedSubview(blocked)
        middleStack.addArrangedSubview(view)
        middleStack.distribution = .fillProportionally

        more.setTitle("More >", for: .normal)
        
        more.setTitleColor(.black, for: .normal)

        more.layer.borderWidth = 1
        more.layer.borderColor = UIColor.gray.cgColor
        more.layer.cornerRadius = StyleTokens.buttonCornerRadius
        
        var spacer = UIView()
        more.translatesAutoresizingMaskIntoConstraints = false
        spaceAnchor = spacer.widthAnchor.constraint(equalToConstant: 250)
        
        spaceAnchor.isActive = true

        let bottomView = UIView()
        
        
        //bottomStack.addArrangedSubview(spacer)

        //bottomStack.addArrangedSubview(more)
        
        //bottomStack.alignment = .trailing
        //bottomStack.distribution = .equalSpacing
        
        stack.addArrangedSubview(topStack)
        stack.addArrangedSubview(middleStack)
        //stack.addArrangedSubview(bottomStack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 12
        stack.distribution = .equalSpacing
        
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            //stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.addSubview(more)
        
        NSLayoutConstraint.activate([
            more.topAnchor.constraint(equalTo: stack.bottomAnchor),
            
            more.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            more.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            more.widthAnchor.constraint(equalToConstant: 100)
            
        ])

        more.titleEdgeInsets = UIEdgeInsets(top: 0,left: 8,bottom: 0,right: 8)
        more.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
        more.isEnabled = true
        
    }
    
    @objc func readySwitch(){
        delegate?.changeStatusFor(.ready)
        //tatus(.ready)
        updateButtonColors(.ready)
    }
    
    @objc func inProgressSwitch(){
        delegate?.changeStatusFor(.inProgress)
        //selectStatus(.inProgress)
        updateButtonColors(.inProgress)

    }
    
    @objc func doneSwitch(){
        delegate?.changeStatusFor(.done)
        //selectStatus(.done)
        updateButtonColors(.done)

    }
    
    @objc func blockedSwitch(){
        delegate?.changeStatusFor(.blocked)
        //selectStatus(.blocked)
        updateButtonColors(.blocked)

    }
    
    func selectStatus(_ status:ToDoTaskStatus){
        
        switch status {
        case .ready:
            ready.backgroundColor = .green
            blocked.backgroundColor = .gray
            inProgress.backgroundColor = .gray
            done.backgroundColor = .gray

        case .inProgress:
            ready.backgroundColor = .gray
            blocked.backgroundColor = .gray
            inProgress.backgroundColor = .purple
            done.backgroundColor = .gray
            
        case .done:
            ready.backgroundColor = .gray
            blocked.backgroundColor = .gray
            inProgress.backgroundColor = .gray
            done.backgroundColor = .blue

        case .blocked:
            ready.backgroundColor = .gray
            blocked.backgroundColor = .red
            inProgress.backgroundColor = .gray
            done.backgroundColor = .gray

        default:
            return
        }
    }
    
    func updateButtonColors(_ status: ToDoTaskStatus){
        switch status {
        case .ready:
            ready.backgroundColor = StyleTokens.readySelected
            inProgress.backgroundColor = StyleTokens.inProgressUnSelected
            done.backgroundColor = StyleTokens.doneUnSelected
            blocked.backgroundColor = StyleTokens.blockedUnSelected

        case .inProgress:
            ready.backgroundColor = StyleTokens.readyUnSelected
            inProgress.backgroundColor = StyleTokens.inProgressSelected
            done.backgroundColor = StyleTokens.doneUnSelected
            blocked.backgroundColor = StyleTokens.blockedUnSelected

        case .done:
            ready.backgroundColor = StyleTokens.readyUnSelected
            inProgress.backgroundColor = StyleTokens.inProgressUnSelected
            done.backgroundColor = StyleTokens.doneSelected
            blocked.backgroundColor = StyleTokens.blockedUnSelected

        case .blocked:
            ready.backgroundColor = StyleTokens.readyUnSelected
            inProgress.backgroundColor = StyleTokens.inProgressUnSelected
            done.backgroundColor = StyleTokens.doneUnSelected
            blocked.backgroundColor = StyleTokens.blockedSelected

        default:
            return
        }
    }
    
    @objc func showDetailView(){
        if let row = row{
            taskDelegate?.showDetailView(row)
        }
    }
}

