//
//  ToDoListGroup.swift
//  ToDoList
//
//  Created by Sean Donato on 9/21/24.
//

import Foundation
struct ToDoListGroup{
    var name: String
    var uuid: UUID
    var lists: [ToDoTask]?
    var items: [ToDoItem]?
    var tasks: [ToDoTask]?

}
