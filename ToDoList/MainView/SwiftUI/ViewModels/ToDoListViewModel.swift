//
//  RootViewModel.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/21/24.
//

import Foundation
import SwiftUI

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
    var items: [ToDoItem]?

    //new. this is the current list
//    var list: ToDoTaskList?
//    var lists: [ToDoTaskList]?
    
    // list replaced with to do task
    var list: ToDoTask?
    var lists: [ToDoTask]?

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
        if let list = coreDataManager?.getList2(listID: list!.uuid){
            self.tasks = list.subTasks
            self.items = list.items
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
        if let list = list{
            if let _ = coreDataManager?.saveTaskWithParent(task, list){
                 fetchData()
            }
        }
    }

    //new
    //todo- what to do on first launch
    
    func saveList(_ toDoListName:String){
        let uuid = UUID()
        
//        let list = ToDoTaskList(name: toDoListName, uuid: uuid, toDoTasks: [],items: [],dateCreated: NSDate())

        let list = ToDoTask(id: uuid, name: toDoListName, uuid: uuid, date:  NSDate())

        //update to save list
        if let _ = coreDataManager?.saveList(list){
            fetchData()
        }
    }
    
    func setList(list: ToDoTask){
        self.list = list
//        self.tasks = list.toDoTasks
        self.tasks = list.subTasks
        toDoListViewModelDelegate?.didFinishFetchingData()
    }
    
    //TODO save item to task
    func saveItem(_ toDoListItemName:String){
        let uuid = UUID()
        //TODO: brand, quantity parameters
        let item = ToDoItem(name: toDoListItemName, brand: "", quantity: 1, uuid: uuid, date: NSDate())
        //save item to task
        if let list = list{
//            if let _ = coreDataManager?.saveItemToList(item, list){
//                 fetchData()
//            }
        }
    }
}
    
