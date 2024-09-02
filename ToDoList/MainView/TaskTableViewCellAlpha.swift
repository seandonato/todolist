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
    
    var selectedStatus: ToDoTaskStatus?
    
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
            statusLabel?.backgroundColor = StyleTokens.readySelected
            labelWidthConstraint.constant = 100

        case .inProgress:
            statusLabel?.text = "in progress"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = StyleTokens.inProgressSelected
            labelWidthConstraint.constant = 130

        case .done:
            statusLabel?.text = "done"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = StyleTokens.doneSelected
            labelWidthConstraint.constant = 80

        case .blocked:
            statusLabel?.text = "blocked"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = StyleTokens.blockedSelected
            labelWidthConstraint.constant = 130

        default:
            statusLabel?.text = "ready"
            statusLabel?.textColor = .white
            statusLabel?.backgroundColor = StyleTokens.readySelected
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

    var buttonStack = UIStackView()
     
    var labelWidth: CGFloat = 100
    var labelWidthConstraint: NSLayoutConstraint!

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
                bStack.selectedStatus = status
            }
        }
    }
    
    var taskView: UIView
    var row : Int?{
        didSet{
            bStack.row = self.row
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
        
        labelWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: labelWidth)
        labelWidthConstraint.isActive = true
        
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
        
        statusLabel.textColor = .white

        bStack.setup()
        buttonStack.addArrangedSubview(bStack)
        buttonStack.spacing = 16
        bStack.delegate = self
        bStack.taskDelegate = self
        bStack.row = self.row
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
        }else{
            bStack.isHidden = true
        }
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
