//
//  Task.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import Foundation

enum ToDoTaskStatus{
    case ready
    case inProgress
    case done
    case blocked
}
struct ToDoTask{
    var name: String
    var uuid: UUID
    var taskStatus: ToDoTaskStatus?
    var note: String?
    var date: NSDate
}

