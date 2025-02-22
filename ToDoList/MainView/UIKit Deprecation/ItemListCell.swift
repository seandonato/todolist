//
//  ItemListCell.swift
//  ToDoList
//
//  Created by Sean Donato on 9/15/24.
//

import Foundation
import UIKit

protocol ItemAcquisitionDelegate: AnyObject{
    func acquiredItem(row: Int, acquired:Bool)
}
class ItemListCell: UITableViewCell{
    
    var row: Int?
    weak var delegate: ItemAcquisitionDelegate?
    var checked: Bool = false{
        didSet{
            checkBox.isHidden = !checked
        }
    }
    var checkBox: UIImageView
    var emptyCheckbox: UIView
    var tapArea: UIView

    var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        tapArea = UIView()
        emptyCheckbox = UIView()
        var checkBoxImage = UIImage(named: "check")
        checkBox = UIImageView(image: checkBoxImage)

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        emptyCheckbox = UIView()

        self.contentView.addSubview(emptyCheckbox)
        self.contentView.addSubview(checkBox)
        self.contentView.addSubview(tapArea)

        emptyCheckbox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        tapArea.translatesAutoresizingMaskIntoConstraints = false


        emptyCheckbox.layer.borderWidth = 1
        emptyCheckbox.layer.borderColor = UIColor.green.cgColor
        emptyCheckbox.layer.cornerRadius = 8
        NSLayoutConstraint.activate([
            emptyCheckbox.heightAnchor.constraint(equalToConstant: 16),
            emptyCheckbox.widthAnchor.constraint(equalToConstant: 16),
            emptyCheckbox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 24),
            emptyCheckbox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            checkBox.heightAnchor.constraint(equalToConstant: 16),
            checkBox.widthAnchor.constraint(equalToConstant: 16),
            checkBox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 24),
            checkBox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            tapArea.heightAnchor.constraint(equalToConstant: 32),
            tapArea.widthAnchor.constraint(equalToConstant: 32),
            tapArea.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 24),
            tapArea.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapCheckbox))
        tap.cancelsTouchesInView = true
        tapArea.addGestureRecognizer(tap)
        self.contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Arial", size: 22)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: emptyCheckbox.trailingAnchor,constant:16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapCheckbox(){
        if let delegate = delegate, let row = row{
            checked = !checked
            delegate.acquiredItem(row: row, acquired: checked)
        }
    }
}
