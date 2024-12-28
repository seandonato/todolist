//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Sean Donato on 9/24/24.
//

import Foundation
import Foundation
import UIKit

protocol ListViewModelDelegate: AnyObject {
    func didFinishFetchingData()
}
class ListViewModel{
    
    var delegate: ListGroupViewModelDelegate?
    var lists: [ToDoTask]?
    
    var group: ToDoListGroup?

    var coreDataManager: ListCoreDataManager?

    init(lists: [ToDoTask]? = nil, coreDataManager: ListCoreDataManager? = nil) {
        self.lists = lists
        self.coreDataManager = coreDataManager
    }
    
    func fetchLists(){
        guard let groupID = self.group?.uuid else { return }
        if let lists =  self.coreDataManager?.getListsByGroup(groupID: groupID ){
            self.lists = lists
            delegate?.didFinishFetchingData()
        }
    }
    func saveList(_ toDoListName:String){
        let uuid = UUID()
        let list = ToDoTask(id: uuid as! UUID,name: toDoListName, uuid: uuid, date: NSDate(), items: [], subTasks: [])

        //update to save list
        if let group{
            if let _ = coreDataManager?.saveListWithGroup(list, group){
                fetchLists()
            }

        }
    }
    func deleteList(_ toDoListID:UUID){
        if coreDataManager?.deleteList(toDoListID) == true{
            fetchLists()
        }
    }
}
