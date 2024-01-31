//
//  Task.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import Foundation

enum TaskStatus{
    case ready
    case inProgress
    case done
    case blocked
}
struct Task{
    var name : String
    var uuid : UUID
    var status : String
    var taskStatus : TaskStatus?
    var notes : String?
}

