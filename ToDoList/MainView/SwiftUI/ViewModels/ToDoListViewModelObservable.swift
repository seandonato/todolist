//
//  File.swift
//  ToDoList
//
//  Created by Sean Donato on 12/28/24.
//

import Foundation

@available(iOS 17.0, *)
@Observable
class ToDoListViewModelObservable: ToDoListViewModelProtocol, StatusPickerDelegate{
    var tasks: [ToDoTask]?
    
    var items: [ToDoItem]?
    
    // list replaced with to do task
    var toDoTask: ToDoTask?
    //var lists: [ToDoTask]?

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
    
    //instead of fetching tasks, fetch the tasks associated with list
    func fetchData() {
        // change to get list
        guard let uuid = toDoTask?.uuid else{
            return
        }
        if let toDoTask = coreDataManager?.getList2(listID: uuid){
            self.tasks = toDoTask.subTasks
            self.items = toDoTask.items
            toDoListViewModelDelegate?.didFinishFetchingData()
        }

//        if let lists = coreDataManager?.getLists(){
//            self.lists = lists
//
//        }//if let tasks = coreDataManager?.getTasks(){
//            self.tasks = tasks
//            toDoListViewModelDelegate?.didFinishFetchingData()
//        }
    }
    
    func deleteTask(_ task: ToDoTask) {
       
        if let _ = coreDataManager?.deleteTask(task){
            fetchData()
        }
        
    }
    func deleteItem(_ item: ToDoItem) {
       
        if let _ = coreDataManager?.deleteItem(item){
            fetchData()
        }
        
    }
    func saveTask(_ toDoTaskName:String){
        let uuid = UUID()
        let task = ToDoTask(id: uuid, name: toDoTaskName , uuid: uuid,date: NSDate())
        //new
        if let toDoTask = toDoTask{
            if let _ = coreDataManager?.saveTaskWithParent(task, toDoTask){
                 fetchData()
            }
        }
    }

    //new
    //todo- what to do on first launch
    func saveList(_ toDoListName:String){
        let uuid = UUID()
        
        let list = ToDoTask(id: uuid, name: toDoListName, uuid: uuid, date:  NSDate())

        //update to save list
        if let _ = coreDataManager?.saveList(list){
            fetchData()
        }
    }
    
    func setList(list: ToDoTask){
        self.toDoTask = list
//        self.tasks = list.toDoTasks
        self.tasks = list.subTasks
        toDoListViewModelDelegate?.didFinishFetchingData()
    }
    
// change to save from 
//    func saveItem(_ toDoListItemName:String){
//        let uuid = UUID()
//        //TODO: brand, quantity parameters
//        let item = ToDoItem(name: toDoListItemName, brand: "", quantity: 1, uuid: uuid, date: NSDate())
//        //new
//        if let list = list{
//            if let _ = coreDataManager?.saveItemToList(item, list){
//                 fetchData()
//            }
//        }
//    }
}
    
