//
//  StatusPicker.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 1/30/24.
//

import UIKit

class StatusPicker: UIView,UIGestureRecognizerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let readyLabel : UILabel = UILabel()
    let inProgressLabel : UILabel = UILabel()
    let blockedLabel : UILabel = UILabel()
    let doneLabel : UILabel = UILabel()
    
    lazy var stack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .equalSpacing
        return stack
    }()
    let statusStack = UIStackView()

    override init(frame: CGRect) {
        
        readyLabel.text = "Ready"
        inProgressLabel.text = "In Progress"
        blockedLabel.text = "Blocked"
        doneLabel.text = "Done"
        
        readyLabel.sizeToFit()
        inProgressLabel.sizeToFit()
        blockedLabel.sizeToFit()
        doneLabel.sizeToFit()

        super.init(frame: frame)
        setupView()
    }
    var currentView = UIView()
    func setupView(){
        stack.addArrangedSubview(readyLabel)
        stack.addArrangedSubview(inProgressLabel)
        stack.addArrangedSubview(blockedLabel)
        stack.addArrangedSubview(doneLabel)
        
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor,constant: 32),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16)
        ])
        self.backgroundColor = .white
        self.setNeedsLayout()

        let yellowView = UIView()
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yellowView.widthAnchor.constraint(equalToConstant: readyLabel.frame.width + 16),
            yellowView.heightAnchor.constraint(equalToConstant: readyLabel.frame.height)
        ])
        
        yellowView.backgroundColor = .yellow
        currentView = yellowView
        var readyGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: yellowView)
        readyGesture.addTarget(self, action: #selector(statusTransition))
        readyLabel.addGestureRecognizer(readyGesture)
        readyGesture.delegate = self
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        blueView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blueView.widthAnchor.constraint(equalToConstant: inProgressLabel.frame.width + 16),
            blueView.heightAnchor.constraint(equalToConstant: inProgressLabel.frame.height)
        ])
        var progGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: blueView)
        progGesture.addTarget(self, action: #selector(statusTransition))
        inProgressLabel.addGestureRecognizer(progGesture)
        progGesture.delegate = self

        let greenView = UIView()
        greenView.backgroundColor = .green
        greenView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            greenView.widthAnchor.constraint(equalToConstant: doneLabel.frame.width + 16),
            greenView.heightAnchor.constraint(equalToConstant: doneLabel.frame.height)
        ])
        var doneGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: greenView)
        doneGesture.addTarget(self, action: #selector(statusTransition))
        doneLabel.addGestureRecognizer(doneGesture)
        doneGesture.delegate = self


        let redView = UIView()
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        var blockedGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: redView)
        blockedGesture.addTarget(self, action: #selector(statusTransition))
        blockedLabel.addGestureRecognizer(blockedGesture)
        blockedGesture.delegate = self

        NSLayoutConstraint.activate([
            redView.widthAnchor.constraint(equalToConstant: blockedLabel.frame.width + 16),
            redView.heightAnchor.constraint(equalToConstant: blockedLabel.frame.height)
        ])

        statusStack.axis = .horizontal
        statusStack.addArrangedSubview(yellowView)
        statusStack.addArrangedSubview(blueView)
        statusStack.addArrangedSubview(redView)
        statusStack.addArrangedSubview(greenView)

        self.addSubview(statusStack)
        statusStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusStack.topAnchor.constraint(equalTo: stack.bottomAnchor,constant: 16),
            statusStack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8)
        ])
        readyLabel.isUserInteractionEnabled = true
        inProgressLabel.isUserInteractionEnabled = true
        doneLabel.isUserInteractionEnabled = true
        blockedLabel.isUserInteractionEnabled = true
        redView.alpha = 0.0
        blueView.alpha = 0.0
        greenView.alpha = 0.0
        stack.isUserInteractionEnabled = true
    }
    
    @objc func statusTransition(sender:MyTapGesture){
        if currentView != sender.statusView
        {
            UIView.animate(withDuration: 1.5) {
                self.currentView.alpha = 0.0
                sender.statusView.alpha = 1.0
                self.currentView = sender.statusView
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MyTapGesture: UITapGestureRecognizer {
    var statusView : UIView
    init(target: Any?, action: Selector?,statusView:UIView) {
        self.statusView = statusView
        super.init(target: target, action: action)
    }
}
