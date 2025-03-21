//
//  ToDoListProject.swift
//  ToDoList
//
//  Created by Sean Donato on 9/21/24.
//

import Foundation
struct ToDoListProject:Identifiable, Comparable{
    static func < (lhs: ToDoListProject, rhs: ToDoListProject) -> Bool {
        return lhs.uuid.hashValue < rhs.uuid.hashValue
    }
    
    static func == (lhs: ToDoListProject, rhs: ToDoListProject) -> Bool {
        return lhs.uuid == rhs.uuid

    }
    
    var id: UUID
    var name: String
    var uuid: UUID
    //var lists: [ToDoTask]?
    var items: [ToDoItem]?
    var tasks: [ToDoTask]?
    var readyTasks: Int?
    var inProgressTasks: Int?
    var blockedTasks: Int?
    var doneTasks: Int?
}
