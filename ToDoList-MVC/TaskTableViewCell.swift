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
class TaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    var titleLabel = UILabel()
    var statusLabel = UILabel()
    func setup(){
        
            self.contentView.addSubview(titleLabel)
            self.contentView.addSubview(statusLabel)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            statusLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:16),

                statusLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor,constant: 0),
                statusLabel.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor,constant: 16)

            ])

        
        
    }
}
