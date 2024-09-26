//
//  GroupListViewModel.swift
//  ToDoList
//
//  Created by Sean Donato on 9/23/24.
//

import Foundation
import UIKit

protocol ListGroupViewModelDelegate: AnyObject {
    func didFinishFetchingData()
}
class ListGroupViewModel{
    
    var delegate: ListGroupViewModelDelegate?
    var groups: [ToDoListGroup]?

    var coreDataManager: GroupCoreDataManager?

    init(groups: [ToDoListGroup]? = nil, coreDataManager: GroupCoreDataManager? = nil) {
        self.groups = groups
        self.coreDataManager = coreDataManager
    }
    
    func fetchGroups(){
        if let groups =  self.coreDataManager?.getGroups(){
            self.groups = groups
            delegate?.didFinishFetchingData()
        }
    }
    func saveGroup(_ listGroupName:String){
        let uuid = UUID()
        let group = ToDoListGroup(name: listGroupName , uuid: uuid)
        //new
            if let _ = coreDataManager?.saveGroup(group){
                fetchGroups()
            }
        
    }
    
}
