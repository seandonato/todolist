//
//  RootViewModel.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/21/24.
//

import Foundation

protocol ToDoListViewModelDelegate: AnyObject {
    func didFinishFetchingData()
}

protocol ToDoListViewModelProtocol: AnyObject{
    var toDoListViewModelDelegate: ToDoListViewModelDelegate? { get set }
    var coreDataManager: CoreDataManager? { get set }
    func deleteTask(_ task: ToDoTask)
    func saveTask(_ toDoTaskName:String)
    func fetchData()
    var tasks : [ToDoTask]? { get set }
}
class ToDoListViewModel: ToDoListViewModelProtocol, StatusPickerDelegate{
    var tasks: [ToDoTask]?
    
    func changeStatusFor(_ task: ToDoTask,_ status: ToDoTaskStatus) {
        coreDataManager?.updateTaskStatus(task, status){result in
            switch result{
            case .success(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchData()
                }
            case .failure(_):
                return
            }
        }
    }
    
    var coreDataManager: CoreDataManager?
    
    var toDoListViewModelDelegate: ToDoListViewModelDelegate?
    
    func fetchData() {
        if let tasks = coreDataManager?.getTasks(){
            self.tasks = tasks
            toDoListViewModelDelegate?.didFinishFetchingData()
        }
    }
    
    func deleteTask(_ task: ToDoTask) {
       
        if let _ = coreDataManager?.deleteTask(task){
            fetchData()
        }
        
    }
    
    func saveTask(_ toDoTaskName:String){
        let uuid = UUID()
        let task = ToDoTask(name: toDoTaskName , uuid: uuid,date: NSDate())
        if let _ = coreDataManager?.saveTask(task){
            fetchData()
        }

    }

}
    
