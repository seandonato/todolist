//
//  TaskTableViewCell.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import UIKit

enum taskStatus {
    case ready
    case done
    case blocked
}

protocol TaskCellDelegate : NSObject{
    func deleteTask(_ task:Task?)
    func showDetailView(_ indexPath: IndexPath?)
}

protocol TaskTableDelegate : NSObject{
    func refreshTasks()
}

class TaskTableViewCell: UITableViewCell, StatusPickerDelegate {
    func changeStatusFor(_ task:Task, status: TaskStatus) {
        CoreDataManager().updateTaskStatus(task, status){result in
            switch result{
            case .success(_):
                self.taskTabledelegate?.refreshTasks()
            case .failure(_):
                return
            }
        }
    }
    
    func changeStatus(status: TaskStatus) {
        if let task = task{
            CoreDataManager().updateTaskStatus(task, status){result in
                switch result{
                case .success(_):
                    self.taskTabledelegate?.refreshTasks()
                case .failure(_):
                    return
                }
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    weak var taskTabledelegate : TaskTableDelegate?

    weak var taskDelegate : TaskCellDelegate?

    var task : Task?{
        didSet{
            if let s = statusSwitcher{
                if let t = task?.taskStatus{
                    if statusSwitcher?.status != t{
                        statusSwitcher?.status = t
                        statusSwitcher?.cycleStatusNoAnimation(t)
                    }
                }
                //setup()
            }
        }
    }
    
    weak var delegate : TaskTableDelegate?
    var taskView : UIView
    var leftView : UIView
    var rightView : UIView
    let deleteView : UIView
    var panGestureRec : UIPanGestureRecognizer
    var tapGestureRec : UITapGestureRecognizer
    var deleteGesture : UITapGestureRecognizer
    var indexPath : IndexPath?
    
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
    var statusLabel = UILabel()
    
    func setup(){
        
        deleteView.backgroundColor = .red
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(deleteView)
        NSLayoutConstraint.activate([
            deleteView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0),
            deleteView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: 0),
            deleteView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:0),
            deleteView.widthAnchor.constraint(equalToConstant: 200)
        ])
        deleteView.addGestureRecognizer(deleteGesture)

        titleLabel.addGestureRecognizer(tapGestureRec)
        titleLabel.isUserInteractionEnabled = true
        tapGestureRec.addTarget(self, action: #selector(goToDetail))
        deleteGesture.addTarget(self, action: #selector(deleteTask))

        taskView.backgroundColor = .white
        taskView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(taskView)
        NSLayoutConstraint.activate([
            taskView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0),
            taskView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: 0),
            taskView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:0),
            taskView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant:0)
        ])

        taskView.addSubview(titleLabel)
        
        statusSwitcher = StatusSwitcher(frame: CGRect(x: 0, y: 0, width: 100, height: 36), self.task?.taskStatus ?? .ready)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusSwitcher?.translatesAutoresizingMaskIntoConstraints = false
        statusSwitcher?.delegate = self
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: taskView.topAnchor,constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: taskView.bottomAnchor,constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: taskView.leadingAnchor,constant:16)
        ])
        
        if let switcher = statusSwitcher{
            taskView.addSubview(switcher)

            NSLayoutConstraint.activate([
                switcher.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor,constant: 0),
                switcher.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor,constant: 16),
                switcher.widthAnchor.constraint(equalToConstant: 100),
                switcher.heightAnchor.constraint(equalToConstant: 36)

            ])
            switcher.panGestureRecognizer?.cancelsTouchesInView =  true
        }
        
        taskView.addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightView.topAnchor.constraint(equalTo: taskView.topAnchor,constant: 12),
            rightView.bottomAnchor.constraint(equalTo: taskView.bottomAnchor,constant: -12),
            rightView.trailingAnchor.constraint(equalTo: taskView.trailingAnchor,constant:16),
            rightView.widthAnchor.constraint(equalToConstant: 200),
            rightView.heightAnchor.constraint(equalTo: taskView.heightAnchor)
        ])
        rightView.addGestureRecognizer(panGestureRec)
        
        layoutIfNeeded()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        if location.x < self.frame.width/2{
//            dump(event)
//            gestureRecognizerIsPannable()
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        if location.x < self.frame.width/2{
//            dump(event)
//            gestureRecognizerIsPannable()
//        }
//    }
    func gestureRecognizerIsPannable(){
        
        //self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Timer fired!")
           // self.isUserInteractionEnabled = true

        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    var initialCenter = CGPoint(x: 0, y: 0)
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let translation = sender.translation(in: self)
            initialCenter = taskView.center

           // print(translation)

        case .changed:
            let translation = sender.translation(in: self)

            taskView.center = CGPoint(x: initialCenter.x + translation.x,
                                          y: initialCenter.y )
            
        case .ended:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.5) {
                    self.taskView.frame.origin = CGPoint(x: 0,
                                           y: 0)
                }
            }
        default:
            break
        }
    }

    @objc func goToDetail(){
        taskDelegate?.showDetailView(self.indexPath)
    }
    @objc func deleteTask(){
        taskDelegate?.deleteTask(task )
    }
}
