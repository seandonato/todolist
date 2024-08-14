//
//  ListTableViewCell.swift
//  ToDoList
//
//  Created by Sean Donato on 4/27/24.
//

import Foundation
import UIKit

class ListTableViewCell: UITableViewCell{
    
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
    
    var toDoList: ToDoTaskList?{
        didSet{
            titleLabel.text = toDoList?.name
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

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var deleteLabel = UILabel()
    var statusLabel = UILabel()
    
    func setup(){
        

        contentView.addGestureRecognizer(tapGestureRec)
        tapGestureRec.cancelsTouchesInView = false
        titleLabel.isUserInteractionEnabled = true
        tapGestureRec.addTarget(self, action: #selector(goToDetail))
        deleteGesture.addTarget(self, action: #selector(deleteTask))

     

        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .gray
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:16)
        ])
        

        layoutIfNeeded()
    }
    
   
    @objc func goToDetail(){
        if let row = row{
            taskDelegate?.showDetailView(row)
        }
    }
    @objc func deleteTask(){
        if let list = toDoList{
           // viewModel?.deleteTask(toDoTask)
        }
    }
}
