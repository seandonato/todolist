//
//  Task.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import Foundation

enum ToDoTaskStatus: String{
    case ready = "ready"
    case inProgress = "inProgress"
    case done = "done"
    case blocked = "blocked"
}

struct ToDoTask{
    
    var name: String
    var uuid: UUID
    var taskStatus: ToDoTaskStatus?
    var note: String?
    var date: NSDate
    var expanded: Bool = false
    var items: [ToDoItem]?
    var subTasks: [ToDoTask]?
    
    //new for syncronization
    var lastUpdatedLocally: NSDate?
    var lastUpdatedFromRemote: NSDate?
    
}

