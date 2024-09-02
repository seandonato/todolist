//
//  AddTaskCell.swift
//  ToDoList
//
//  Created by Sean Donato on 4/17/24.
//

import Foundation
import UIKit
protocol AddTaskDelegate: AnyObject{
    func addTask()
}
class AddTaskCell: UITableViewCell{
    
    weak var delegate: AddTaskDelegate?
    var viewModel: ToDoListViewModel?

    var coreDataManager: CoreDataManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var tapGestureRec: UITapGestureRecognizer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        tapGestureRec = UITapGestureRecognizer()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addGestureRecognizer(tapGestureRec)
        tapGestureRec.addTarget(self, action: #selector(addTask))
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    var titleLabel = UILabel()
    
    func setup(){
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //titleLabel.text = "+ Add Task"
        
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:16)
        ])
    }
    
    @objc func addTask(){
        delegate?.addTask()
    }
    
}
