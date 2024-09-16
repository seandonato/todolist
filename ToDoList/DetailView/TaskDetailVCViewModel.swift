//
//  TaskDetailVCViewModel.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/22/24.
//

import Foundation

protocol TaskDetailVCViewModelProtocol: AnyObject{
    var coreDataManager: CoreDataManager? { get set }
    func saveNote(_ task:ToDoTask,_ text:String)
    var toDoTask: ToDoTask { get }
}

class TaskDetailVCViewModel: TaskDetailVCViewModelProtocol, StatusPickerDelegate{
    
    init(toDoTask: ToDoTask, coreDataManager: CoreDataManager? = nil) {
        self.toDoTask = toDoTask
        self.coreDataManager = coreDataManager
    }
    var toDoTask: ToDoTask
    
    var coreDataManager: CoreDataManager?
    
    func changeStatusFor(_ task: ToDoTask,_ status: ToDoTaskStatus) {
        coreDataManager?.updateTaskStatus(task, status){result in
            switch result{
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }

    func saveNote(_ task:ToDoTask,_ text:String){
        coreDataManager?.updateTaskNotes(task, text)
    }
    func saveItem(_ item:ToDoTaskItem){
       // coreDataManager?.updateTaskNotes(task, text)
        coreDataManager?.saveItemToTask(item, self.toDoTask)
    }

}
    
