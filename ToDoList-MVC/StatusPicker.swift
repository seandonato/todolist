//
//  StatusPicker.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 1/30/24.
//

import UIKit

class StatusPicker: UIView {

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
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        blueView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blueView.widthAnchor.constraint(equalToConstant: inProgressLabel.frame.width + 16),
            blueView.heightAnchor.constraint(equalToConstant: inProgressLabel.frame.height)
        ])

        let greenView = UIView()
        greenView.backgroundColor = .green
        greenView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            greenView.widthAnchor.constraint(equalToConstant: doneLabel.frame.width + 16),
            greenView.heightAnchor.constraint(equalToConstant: doneLabel.frame.height)
        ])


        let redView = UIView()
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false

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

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
