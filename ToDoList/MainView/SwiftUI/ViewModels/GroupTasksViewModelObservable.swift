//
//  GroupTasksViewModelObservable.swift
//  ToDoList
//
//  Created by Sean Donato on 2/1/25.
//

import Foundation
import UIKit

//protocol ListViewModelDelegate: AnyObject {
//    func didFinishFetchingData()
//}
@available(iOS 17.0, *)
@Observable
class GroupTasksViewModelObservable{
    
    var delegate: ListGroupViewModelDelegate?
    var lists: [ToDoTask]?
    
    var group: ToDoListGroup?

    var coreDataManager: ListCoreDataManager?
    var genCoreDataManager: CoreDataManager?

    init(lists: [ToDoTask]? = nil, coreDataManager: ListCoreDataManager? = nil) {
        self.lists = lists
        self.coreDataManager = coreDataManager
    }
    
    func fetchLists(){
        guard let groupID = self.group?.uuid else { return }
        if let lists =  self.coreDataManager?.getListsByGroup(groupID: groupID ){
            self.lists = lists.sorted()
            delegate?.didFinishFetchingData()
        }
    }
    func saveTask(_ toDoListName:String){
        let uuid = UUID()
        let task = ToDoTask(id: uuid as! UUID,name: toDoListName, uuid: uuid, date: NSDate(), items: [], subTasks: [])

        //update to save list
        if let group{
            if let _ = coreDataManager?.saveTaskWithGroup(task, group: group){
                fetchLists()
            }

        }
    }
    func deleteList(_ toDoListID:UUID){
        if coreDataManager?.deleteList(toDoListID) == true{
            fetchLists()
        }
    }
    
    func changeStatusFor(_ task: ToDoTask,_ status: ToDoTaskStatus) {
        genCoreDataManager?.updateTaskStatus(task, status){result in
            switch result{
            case .success(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchLists()
                }
            case .failure(_):
                return
            }
        }
    }

}
