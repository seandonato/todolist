//
//  TDLButton.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 1/2/24.
//

import Foundation
import UIKit

class TDLButton :UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    func style(){
        self.backgroundColor = .blue
        self.layer.cornerRadius = 16
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
