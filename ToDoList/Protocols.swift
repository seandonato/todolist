//
//  Protocols.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/8/24.
//

import Foundation


protocol TaskCellDelegate : AnyObject{
    func showDetailView(_ row: Int)
}

protocol StatusPickerDelegate: AnyObject{
    func changeStatusFor(_ task:ToDoTask,_ status:ToDoTaskStatus)
}
