//
//  TaskTableViewCellAlpha.swift
//  ToDoList
//
//  Created by Sean Donato on 8/13/24.
//

import Foundation
import UIKit

class TaskTableViewCellAlpha: UITableViewCell{
    
    var moreButton = UIButton()
    var statusButton = UIButton()

    var expanded: Bool?
 
    var viewModel: ToDoListViewModel?
    weak var taskDelegate: TaskCellDelegate?
    var coreDataManager: CoreDataManager?

    var bottomConstraint: NSLayoutConstraint!
    var bottomConstant: CGFloat = 0.0
    
    var heightConstraint: NSLayoutConstraint!
    var heightConstant: CGFloat = 0.0

    var bStack = StatusButtonStack(frame: .zero)
    var buttonStack = UIStackView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var toDoTask: ToDoTask?{
        didSet{
            titleLabel.text = toDoTask?.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short

            if let d = toDoTask?.date{
                dateLabel.text = dateFormatter.string(from: d as Date)
            }
           // guard let statusSwitcher = statusSwitcher else {return}
//            statusSwitcher.toDoTask = toDoTask
//            if let status = toDoTask?.taskStatus{
//                if statusSwitcher.status != status{
//                    statusSwitcher.status = status
//                    statusSwitcher.cycleStatusNoAnimation(status)
//                }
//            }
        }
    }
    
    var taskView: UIView
    var row : Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        taskView = UIView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 50),
            buttonStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -50),
            buttonStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        buttonStack.axis = .vertical
        moreButton.setTitle("more", for: .normal)
        statusButton.setTitle("status", for: .normal)

        moreButton.backgroundColor = .blue
        statusButton.backgroundColor = .blue
        buttonStack.addArrangedSubview(moreButton)
        bStack.setup()
        buttonStack.addArrangedSubview(bStack)

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    var switcherLabel = UILabel()
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var deleteLabel = UILabel()
    var statusLabel = UILabel()
    
    func setup(){
        if expanded == true{
            bStack.isHidden = false
        }else{
            bStack.isHidden = true
        }
    }
    func setup2(){
        if expanded == true{
            heightConstant = 200
        }else{
            heightConstant = 100
        }

        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: heightConstant)
        
        heightConstraint.isActive = true
        titleLabel.isUserInteractionEnabled = true

        taskView.backgroundColor = UIColor(named: "Background")
        taskView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(taskView)
        NSLayoutConstraint.activate([
            taskView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0),
            taskView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: 0),
            taskView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:0),
            taskView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:bottomConstant)
        ])

        taskView.addSubview(titleLabel)
        

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Arial", size: 22)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: taskView.topAnchor,constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: taskView.leadingAnchor,constant:16)
        ])
        
        dateLabel.font = UIFont(name: "Arial", size: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: taskView.leadingAnchor,constant:16)
        ])

        switcherLabel.translatesAutoresizingMaskIntoConstraints = false
        switcherLabel.text = self.toDoTask?.taskStatus?.rawValue
       // if let switcher = switcherLabel{
            taskView.addSubview(switcherLabel)
            NSLayoutConstraint.activate([
                switcherLabel.topAnchor.constraint(equalTo: self.taskView.topAnchor,constant: 10),
                //switcherLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16),
                switcherLabel.trailingAnchor.constraint(equalTo: self.taskView.trailingAnchor,constant: -16),
                switcherLabel.widthAnchor.constraint(equalToConstant: 100),
                switcherLabel.heightAnchor.constraint(equalToConstant: 36)

            ])
            //switcher.panGestureRecognizer?.cancelsTouchesInView =  true
       // }
        
        bottomConstraint = switcherLabel.bottomAnchor.constraint(equalTo: self.taskView.bottomAnchor, constant: bottomConstant)

        //bottomConstraint.isActive = true

        moreButton.setTitle("More", for: .normal)
        moreButton.backgroundColor = .blue
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        taskView.addSubview(moreButton)
        if let exp = expanded{
            moreButton.isHidden = !exp 
            if exp == true{
                bottomConstraint.isActive = false

                bottomConstant = 100
                bottomConstraint.isActive = true


            }else{
                bottomConstraint.isActive = false

                bottomConstant = 0
                bottomConstraint.isActive = true

            }
        }
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: switcherLabel.bottomAnchor,constant: 10),
            //moreButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16),
            moreButton.trailingAnchor.constraint(equalTo: self.taskView.trailingAnchor,constant: -16),
            moreButton.widthAnchor.constraint(equalToConstant: 100),
            moreButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        
//        taskView.addSubview(rightView)
//        
//        rightView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            rightView.topAnchor.constraint(equalTo: taskView.topAnchor,constant: 0),
//            rightView.bottomAnchor.constraint(equalTo: taskView.bottomAnchor,constant: -12),
//            rightView.trailingAnchor.constraint(equalTo: taskView.trailingAnchor,constant:16),
//            rightView.widthAnchor.constraint(equalToConstant: 100),
//            rightView.heightAnchor.constraint(equalTo: taskView.heightAnchor)
//        ])
//        rightView.addGestureRecognizer(panGestureRec)
        
        layoutIfNeeded()
    }
    
    var initialCenter = CGPoint(x: 0, y: 0)
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            initialCenter = taskView.center

        case .changed:
            let translation = sender.translation(in: self)

            taskView.center = CGPoint(x: initialCenter.x + translation.x,
                                          y: initialCenter.y )
            
        case .ended:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.6) {
                    self.taskView.frame.origin = CGPoint(x: 0,
                                           y: 0)
                }
            }
        default:
            break
        }
    }

    @objc func goToDetail(){
        if let row = row{
            //taskDelegate?.showDetailView(row)
        }
    }
    @objc func deleteTask(){
        if let toDoTask = toDoTask{
            viewModel?.deleteTask(toDoTask)
        }
    }
    
//    override func prepareForReuse() {
//        statusSwitcher = nil
//    }
}
