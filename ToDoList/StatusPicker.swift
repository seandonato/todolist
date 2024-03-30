//
//  StatusPicker.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 1/30/24.
//

import UIKit

//class StatusPicker: UIView {
//}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    weak var delegate : StatusPickerDelegate?
//    let readyLabel : UILabel = UILabel()
//    let inProgressLabel : UILabel = UILabel()
//    let blockedLabel : UILabel = UILabel()
//    let doneLabel : UILabel = UILabel()
//    
//    lazy var stack : UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 16
//        stack.distribution = .equalSpacing
//        return stack
//    }()
//    let statusStack = UIStackView()
//
//    override init(frame: CGRect) {
//        
//        readyLabel.text = "Ready"
//        inProgressLabel.text = "In Progress"
//        blockedLabel.text = "Blocked"
//        doneLabel.text = "Done"
//        
//        readyLabel.sizeToFit()
//        inProgressLabel.sizeToFit()
//        blockedLabel.sizeToFit()
//        doneLabel.sizeToFit()
//
//        super.init(frame: frame)
//        setupView()
//    }
//    var currentView = UIView()
//    func setupView(){
//        stack.addArrangedSubview(readyLabel)
//        stack.addArrangedSubview(inProgressLabel)
//        stack.addArrangedSubview(blockedLabel)
//        stack.addArrangedSubview(doneLabel)
//        
//        self.addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: self.topAnchor,constant: 32),
//            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 16)
//        ])
//        self.backgroundColor = .white
//        self.setNeedsLayout()
//
//        let yellowView = UIView()
//        yellowView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            yellowView.widthAnchor.constraint(equalToConstant: readyLabel.frame.width + 16),
//            yellowView.heightAnchor.constraint(equalToConstant: readyLabel.frame.height)
//        ])
//        
//        yellowView.backgroundColor = .green
//        currentView = yellowView
//        var readyGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: yellowView,status: .ready)
//        readyGesture.addTarget(self, action: #selector(statusTransition))
//        readyLabel.addGestureRecognizer(readyGesture)
//        readyGesture.delegate = self
//        
//        let blueView = UIView()
//        blueView.backgroundColor = UIColor(hex: "#c548fa")
//        blueView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            blueView.widthAnchor.constraint(equalToConstant: inProgressLabel.frame.width + 16),
//            blueView.heightAnchor.constraint(equalToConstant: inProgressLabel.frame.height)
//        ])
//        var progGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: blueView,status: .inProgress)
//        progGesture.addTarget(self, action: #selector(statusTransition))
//        inProgressLabel.addGestureRecognizer(progGesture)
//        progGesture.delegate = self
//
//        let greenView = UIView()
//        greenView.backgroundColor = .blue
//        greenView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            greenView.widthAnchor.constraint(equalToConstant: doneLabel.frame.width + 16),
//            greenView.heightAnchor.constraint(equalToConstant: doneLabel.frame.height)
//        ])
//        var doneGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: greenView,status: .done)
//        doneGesture.addTarget(self, action: #selector(statusTransition))
//        doneLabel.addGestureRecognizer(doneGesture)
//        doneGesture.delegate = self
//
//
//        let redView = UIView()
//        redView.backgroundColor = .red
//        redView.translatesAutoresizingMaskIntoConstraints = false
//        var blockedGesture = MyTapGesture(target: self, action: #selector(statusTransition), statusView: redView,status: .blocked)
//        blockedGesture.addTarget(self, action: #selector(statusTransition))
//        blockedLabel.addGestureRecognizer(blockedGesture)
//        blockedGesture.delegate = self
//
//        NSLayoutConstraint.activate([
//            redView.widthAnchor.constraint(equalToConstant: blockedLabel.frame.width + 16),
//            redView.heightAnchor.constraint(equalToConstant: blockedLabel.frame.height)
//        ])
//
//        statusStack.axis = .horizontal
//        statusStack.addArrangedSubview(yellowView)
//        statusStack.addArrangedSubview(blueView)
//        statusStack.addArrangedSubview(redView)
//        statusStack.addArrangedSubview(greenView)
//
//        self.addSubview(statusStack)
//        statusStack.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            statusStack.topAnchor.constraint(equalTo: stack.bottomAnchor,constant: 16),
//            statusStack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8)
//        ])
//        readyLabel.isUserInteractionEnabled = true
//        inProgressLabel.isUserInteractionEnabled = true
//        doneLabel.isUserInteractionEnabled = true
//        blockedLabel.isUserInteractionEnabled = true
//        redView.alpha = 0.0
//        blueView.alpha = 0.0
//        greenView.alpha = 0.0
//        stack.isUserInteractionEnabled = true
//    }
//    
//    @objc func statusTransition(sender:MyTapGesture){
//        if currentView != sender.statusView
//        {
//            UIView.animate(withDuration: 0.5) {
//                self.currentView.alpha = 0.0
//                sender.statusView.alpha = 1.0
//
//                self.delegate?.changeStatus(status: sender.status)
//                self.currentView = sender.statusView
//            }
//        }
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//class MyTapGesture: UITapGestureRecognizer {
//    var statusView : UIView
//    var status : ToDoTaskStatus
//    init(target: Any?, action: Selector?,statusView:UIView,status : ToDoTaskStatus) {
//        self.statusView = statusView
//        self.status = status
//        super.init(target: target, action: action)
//    }
//}
////extension UIColor {
////    public convenience init?(hex: String) {
////        let r, g, b, a: CGFloat
////
////        if hex.hasPrefix("#") {
////            let start = hex.index(hex.startIndex, offsetBy: 1)
////            let hexColor = String(hex[start...])
////
////            if hexColor.count == 8 {
////                let scanner = Scanner(string: hexColor)
////                var hexNumber: UInt64 = 0
////
////                if scanner.scanHexInt64(&hexNumber) {
////                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
////                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
////                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
////                    a = CGFloat(hexNumber & 0x000000ff) / 255
////
////                    self.init(red: r, green: g, blue: b, alpha: a)
////                    return
////                }
////            }
////        }
////
////        return nil
////    }
////}
//extension UIColor {
//    convenience init(hex: String, alpha: CGFloat = 1.0) {
//        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
//
//        if hexValue.hasPrefix("#") {
//            hexValue.remove(at: hexValue.startIndex)
//        }
//
//        var rgbValue: UInt64 = 0
//        Scanner(string: hexValue).scanHexInt64(&rgbValue)
//
//        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
//        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
//
//        self.init(red: red, green: green, blue: blue, alpha: alpha)
//    }
//}
