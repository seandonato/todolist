//
//  TaskTableViewCell.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell{
    
    var viewModel: ToDoListViewModel?
    weak var taskDelegate: TaskCellDelegate?
    var coreDataManager: CoreDataManager?

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
            guard let statusSwitcher = statusSwitcher else {return}
            statusSwitcher.toDoTask = toDoTask
            if let status = toDoTask?.taskStatus{
                if statusSwitcher.status != status{
                    statusSwitcher.status = status
                    statusSwitcher.cycleStatusNoAnimation(status)
                }
            }
        }
    }
    
    var taskView: UIView
    var leftView: UIView
    var rightView: UIView
    let deleteView: UIView
    var panGestureRec: UIPanGestureRecognizer
    var tapGestureRec: UITapGestureRecognizer
    var deleteGesture: UITapGestureRecognizer
    var row : Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        taskView = UIView()
        leftView = UIView()
        rightView = UIView()
        panGestureRec = UIPanGestureRecognizer()
        tapGestureRec = UITapGestureRecognizer()
        deleteGesture = UITapGestureRecognizer()

        deleteView = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        panGestureRec.addTarget(self, action: #selector(didPan))
        panGestureRec.addTarget(self, action: #selector(didPan))

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    var statusSwitcher : StatusSwitcher?
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var deleteLabel = UILabel()
    var statusLabel = UILabel()
    
    func setup(){
        
        deleteView.backgroundColor = .red
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        deleteLabel.text = "Delete"
        deleteLabel.textColor = .white
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(deleteView)
        self.contentView.addSubview(deleteLabel)

        NSLayoutConstraint.activate([
            deleteView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0),
            deleteView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: 0),
            deleteView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:0),
            deleteView.widthAnchor.constraint(equalToConstant: 200),
            deleteLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:-16),
            deleteLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor,constant:0)
        ])
        deleteView.addGestureRecognizer(deleteGesture)

        contentView.addGestureRecognizer(tapGestureRec)
        tapGestureRec.cancelsTouchesInView = false
        titleLabel.isUserInteractionEnabled = true
        tapGestureRec.addTarget(self, action: #selector(goToDetail))
        deleteGesture.addTarget(self, action: #selector(deleteTask))

        taskView.backgroundColor = UIColor(named: "Background")
        taskView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(taskView)
        NSLayoutConstraint.activate([
            taskView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0),
            taskView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: 0),
            taskView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:0),
            taskView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:0)
        ])

        taskView.addSubview(titleLabel)
        
        statusSwitcher = StatusSwitcher(frame: CGRect(x: 0, y: 0, width: 100, height: 36), toDoTask?.taskStatus ?? .ready)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Arial", size: 22)
        statusSwitcher?.translatesAutoresizingMaskIntoConstraints = false
        statusSwitcher?.delegate = self.viewModel
        statusSwitcher?.toDoTask = self.toDoTask
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

        if let switcher = statusSwitcher{
            taskView.addSubview(switcher)
            NSLayoutConstraint.activate([
                switcher.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 10),
                switcher.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
                switcher.bottomAnchor.constraint(equalTo: self.taskView.bottomAnchor,constant: -16),
                switcher.widthAnchor.constraint(equalToConstant: 100),
                switcher.heightAnchor.constraint(equalToConstant: 36)

            ])
            switcher.panGestureRecognizer?.cancelsTouchesInView =  true
        }
        
        taskView.addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightView.topAnchor.constraint(equalTo: taskView.topAnchor,constant: 0),
            rightView.bottomAnchor.constraint(equalTo: taskView.bottomAnchor,constant: -12),
            rightView.trailingAnchor.constraint(equalTo: taskView.trailingAnchor,constant:16),
            rightView.widthAnchor.constraint(equalToConstant: 100),
            rightView.heightAnchor.constraint(equalTo: taskView.heightAnchor)
        ])
        rightView.addGestureRecognizer(panGestureRec)
        
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
            taskDelegate?.showDetailView(row)
        }
    }
    @objc func deleteTask(){
        if let toDoTask = toDoTask{
            viewModel?.deleteTask(toDoTask)
        }
    }
    
    override func prepareForReuse() {
        statusSwitcher = nil
    }
}
