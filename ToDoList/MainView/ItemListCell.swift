//
//  ItemListCell.swift
//  ToDoList
//
//  Created by Sean Donato on 9/15/24.
//

import Foundation
import UIKit

class ItemListCell: UITableViewCell{
    
    var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Arial", size: 22)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
