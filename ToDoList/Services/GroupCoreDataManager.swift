//
//  CoreDataGroupManager.swift
//  ToDoList
//
//  Created by Sean Donato on 4/17/24.
//

import Foundation
import CoreData

class GroupCoreDataManager {
    
    let persistentContainer : NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func saveGroup(_ group: ToDoListProject) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TDGroup", in: managedContext)!
        
        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
        managedTask.setValue(group.name, forKeyPath: "name")
        let uuid = UUID()
        managedTask.setValue(uuid, forKeyPath: "uuid")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteProject(_ project: ToDoListProject) -> Bool? {
   
        let managedContext = persistentContainer.viewContext
        let taskID = project.uuid
        let projectFetch = NSFetchRequest<NSManagedObject>(entityName: "TDGroup")
        
        projectFetch.predicate = NSPredicate(format: "%K == %@", "uuid", taskID as any CVarArg )
        
        do{
            let fetchResults = try managedContext.fetch(projectFetch)
            
            if fetchResults.count != 0{
                let managedObject = fetchResults[0]
                managedContext.delete(managedObject)
                do {
                    try managedContext.save()
                    return true
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                    return false
                }
            }
        }catch{
            print("Could not fetch.")
            return false
        }
        return true
    }

    func getGroups() -> [ToDoListProject]?{
        
        let managedContext = persistentContainer.viewContext
        var groups = [ToDoListProject]()
        guard let managedGroups = fetchGroupsFromCoreData() else {return nil}
        
        for object in managedGroups{
           
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}

            var tasks: [ToDoTask] = []
//            if let tdlists = (object as AnyObject).value(forKey: "lists") as? [TDTask] {
//                for list in tdlists
//                {
//                    guard let name = (list as AnyObject).value(forKey: "name") as? String else{return nil}
//                    guard let uuid = (list as AnyObject).value(forKey: "uuid") as? UUID else{return nil}
//                    guard let date = (list as AnyObject).value(forKey: "date") as? NSDate else{return nil}
//                    let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid, date: date, items: [], subTasks: [])
//                    //guard let items = object
//                    lists.append(list)
//                }

            //}
            if let project = object as? TDGroup{
                            if let mTasks = project.tasks {
                                for mTask in mTasks{
                                    guard let name = (mTask as AnyObject).value(forKey: "name") as? String else{return nil}
                                    guard let uuid = (mTask as AnyObject).value(forKey: "uuid") else{return nil}
                                    let status = (mTask as AnyObject).value(forKey: "status") as? String ?? "ready"
                //
                                    var taskStatus = ToDoTaskStatus.ready
                                    if status == "in progress"{
                                        taskStatus = ToDoTaskStatus.inProgress
                                    }else if status == "done"{
                                        taskStatus = ToDoTaskStatus.done
                                    }else if status == "blocked"{
                                        taskStatus = ToDoTaskStatus.blocked
                                    }
                                    guard let dateCreated = (mTask as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
                
                                   // let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID, date:dateCreated, items: [], subTasks: [])
                                    let task = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID,taskStatus: taskStatus, date:dateCreated, items: [], subTasks: [])
                                    tasks.append(task)
                
                                }
                            }

            }

            let group = ToDoListProject(id: UUID(), name: name, uuid: uuid as! UUID,tasks: tasks)
            groups.append(group)
        }
        
        return groups
    }
    
    func fetchGroupsFromCoreData() -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        let groupsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDGroup")
        var groups : [NSManagedObject] = []
        do {
            groups = try managedContext.fetch(groupsFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return groups
    }
}
