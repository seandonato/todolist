//
//  CoreDataListManager.swift
//  ToDoList
//
//  Created by Sean Donato on 9/23/24.
//

import Foundation
import CoreData
class ListCoreDataManager {
    
    let persistentContainer : NSPersistentContainer
    
    let coreDataUtil: CoreDataUtil
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        coreDataUtil = CoreDataUtil(persistentContainer: persistentContainer)

    }
    func saveTaskWithGroup(_ task: ToDoTask,group: ToDoListProject) -> Bool? {
        let managedContext = persistentContainer.viewContext
        
        //get list
        let groupId = group.uuid
        let groupFetch = NSFetchRequest<NSManagedObject>(entityName: "TDGroup")
        groupFetch.predicate = NSPredicate(format: "%K == %@", "uuid", groupId as any CVarArg )
        do{
            let fetchResults = try managedContext.fetch(groupFetch)
            if !fetchResults.isEmpty{
                
                let managedList = fetchResults[0]
                
                if let mGroup = fetchResults[0] as? TDGroup{
                    
                    let entity = NSEntityDescription.entity(forEntityName: "TDTask", in: managedContext)!
                    
                    let managedList = TDTask(entity: entity, insertInto: managedContext)
                    
                    managedList.setValue(task.name, forKeyPath: "name")
                    let uuid = UUID()
                    managedList.setValue(uuid, forKeyPath: "uuid")
                    managedList.setValue(NSDate(), forKeyPath: "dateCreated")
                    managedList.setValue("ready", forKeyPath: "status")

                    mGroup.addToTasks(managedList)
                    do {
                        try managedContext.save()
                        return true
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                        return false
                    }
                }
                print(fetchResults)
            }
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        return false
    }

    func getTasksByGroup(groupID:UUID) -> [ToDoTask]?{
        
        let managedContext = persistentContainer.viewContext
        var tasks: [ToDoTask]? = []
        guard let managedGroups = coreDataUtil.fetchGroupListsFromCoreData(groupID: groupID) as? [TDGroup] else {return nil}
        
        for object in managedGroups{

            if let mTasks = object.tasks {
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
                    tasks?.append(task)

                }
            }

            }
            return tasks
        }

    func fetchListFromCoreData() -> [NSManagedObject]?{
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
    
    func deleteList(_ listID: UUID) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let listID = listID
        let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        
        listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
        
        do{
            let fetchResults = try managedContext.fetch(listFetch)
            
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

}
