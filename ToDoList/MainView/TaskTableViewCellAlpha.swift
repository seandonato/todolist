//
//  TaskTableViewCellAlpha.swift
//  ToDoList
//
//  Created by Sean Donato on 8/13/24.
//

import Foundation
import UIKit


class TaskTableViewCellAlpha: UITableViewCell,StatusUISwitcher,TaskCellDelegate{
    func showDetailView(_ row: Int) {
            taskDelegate?.showDetailView(row)
    }
    
    func changeStatusFor(_ status: ToDoTaskStatus) {
        guard let task = toDoTask else{
            return
        }
        viewModel?.changeStatusFor(task, status)

      changeStatusColor(status)
    }
    
    func changeStatusColor(_ status: ToDoTaskStatus){
        switch status {
        case .ready:
            statusLabel?.text = "ready"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = .green

        case .inProgress:
            statusLabel?.text = "in progress"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = .purple

            
        case .done:
            statusLabel?.text = "done"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = .blue

            
        case .blocked:
            statusLabel?.text = "blocked"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = .red

            
        default:
            statusLabel?.text = "ready"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = .green

        }
    }
    var moreButton = UIButton()
    
    var statusLabel:StatusLabel? = StatusLabel()

    var expanded: Bool?

    var viewModel: ToDoListViewModel?
    
    weak var taskDelegate: TaskCellDelegate?
    
    var coreDataManager: CoreDataManager?

    var bottomConstraint: NSLayoutConstraint!
    var bottomConstant: CGFloat = 0.0
    
    var heightConstraint: NSLayoutConstraint!
    var heightConstant: CGFloat = 0.0

    var bStack = StatusButtonStack(frame: .zero)
    var mStack = MoreButtonStack(frame: .zero)

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
            statusLabel?.text = toDoTask?.taskStatus?.rawValue
            if let status = toDoTask?.taskStatus{
                changeStatusColor(status)
            }
        }
    }
    
    var taskView: UIView
    var row : Int?{
        didSet{
            mStack.row = row
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        taskView = UIView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Arial", size: 22)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:16)
        ])
        
        guard let statusLabel = statusLabel else{
            return
        }
        statusLabel.layer.cornerRadius = StyleTokens.buttonCornerRadius
        self.contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont(name: "Arial", size: 22)

        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:-16)
        ])

        
        dateLabel.font = UIFont(name: "Arial", size: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:16)
        ])

        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16),
        ])
        
        buttonStack.axis = .vertical
        
        mStack = MoreButtonStack()
        mStack.statusDelegate = self
        mStack.setup()
        mStack.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(mStack)
//        NSLayoutConstraint.activate([
//            mStack.topAnchor.constraint(equalTo: bStack.bottomAnchor,constant: 16),
//            mStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 50),
//            mStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -50),
//            mStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16),
//        ])



        statusLabel.textColor = .white

        //statusLabel.backgroundColor = .blue
        //buttonStack.addArrangedSubview(moreButton)
        bStack.setup()
        buttonStack.addArrangedSubview(bStack)
        buttonStack.addArrangedSubview(mStack)
        buttonStack.spacing = 16
        mStack.row = row
        mStack.delegate = self
        bStack.delegate = self

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
    
    func setup(){
        if expanded == true{
            bStack.isHidden = false
            mStack.isHidden = false
        }else{
            bStack.isHidden = true
            mStack.isHidden = true
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

    @objc func goToDetail(){
        if let row = row{
            taskDelegate?.showDetailView(row)
        }
    }
    @objc func deleteTask(){
        if let toDoTask = toDoTask{
            viewModel?.deleteTask(toDoTask)
        }
    }
    
    @objc func changeStatusReady(){
        if let toDoTask{
            viewModel?.changeStatusFor(toDoTask, .ready)
            statusLabel?.text = ToDoTaskStatus.ready.rawValue
        }
    }
    @objc func changeStatusInProgress(){
        if let toDoTask{
            
            viewModel?.changeStatusFor(toDoTask, .inProgress)
            statusLabel?.text = ToDoTaskStatus.inProgress.rawValue

        }
    }
    @objc func changeStatusDone(){
        if let toDoTask{
            
            viewModel?.changeStatusFor(toDoTask, .done)
            statusLabel?.text = ToDoTaskStatus.done.rawValue

        }
    }
    @objc func changeStatusBlocked(){
        if let toDoTask{
            
            viewModel?.changeStatusFor(toDoTask, .blocked)
            statusLabel?.text = ToDoTaskStatus.blocked.rawValue

        }
    }

    override func prepareForReuse() {
        //statusLabel = nil
       // statusLabel = UILabel()
    }
}
 class StatusLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 8.0
    @IBInspectable var bottomInset: CGFloat = 8.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
        
        self.layer.cornerRadius = StyleTokens.buttonCornerRadius
        self.layer.masksToBounds = true
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
