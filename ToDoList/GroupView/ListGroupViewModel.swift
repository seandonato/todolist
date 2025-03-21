//
//  GroupListViewModel.swift
//  ToDoList
//
//  Created by Sean Donato on 9/23/24.
//

import Foundation
import UIKit

protocol TaskGroupViewModelDelegate: AnyObject {
    func didFinishFetchingData()
}
@available(iOS 17.0, *)
@Observable
class ListGroupViewModel{
    
    var delegate: TaskGroupViewModelDelegate?
    var groups: [ToDoListProject]?

    var coreDataManager: GroupCoreDataManager?

    init(groups: [ToDoListProject]? = nil, coreDataManager: GroupCoreDataManager? = nil) {
        self.groups = groups
        getNumberByStatus()
        self.coreDataManager = coreDataManager
    }
    
    func fetchGroups(){
        if let groups = self.coreDataManager?.getGroups(){
            self.groups = groups
            getNumberByStatus()
            delegate?.didFinishFetchingData()
        }
    }
    
    func saveGroup(_ listGroupName:String){
        let uuid = UUID()
        let group = ToDoListProject(id: UUID(), name: listGroupName , uuid: uuid)
        //new
        if let _ = coreDataManager?.saveGroup(group){
            fetchGroups()
        }
    }
    
    func deleteProject(_ project:ToDoListProject){

        if let _ = coreDataManager?.deleteProject(project){
            fetchGroups()
        }
    }
    func getNumberByStatus(){
        guard let projects = groups else{
            return
        }

        var i = 0
        while i < projects.count{
            
            var tempProject = projects[i]
            var readyTasks = tempProject.tasks?.filter({$0.taskStatus == .ready})
            tempProject.readyTasks = readyTasks?.count
            
            var inProgressTasks = tempProject.tasks?.filter({$0.taskStatus == .inProgress})
            tempProject.inProgressTasks = inProgressTasks?.count

            var blockedTasks = tempProject.tasks?.filter({$0.taskStatus == .blocked})
            tempProject.blockedTasks = blockedTasks?.count

            var doneTasks = tempProject.tasks?.filter({$0.taskStatus == .done})
            tempProject.doneTasks = doneTasks?.count

            groups?[i] = tempProject
            
            i += 1
        }

    }
}
