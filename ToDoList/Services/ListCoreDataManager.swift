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
    //    func saveGroup(_ taskGroup: ToDoTask) -> Bool? {
    //        let managedContext = persistentContainer.viewContext
    //        let entity = NSEntityDescription.entity(forEntityName: "TDList", in: managedContext)!
    //
    //        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
    //        managedTask.setValue(taskGroup.name, forKeyPath: "name")
    //        let uuid = UUID()
    //        managedTask.setValue(uuid, forKeyPath: "uuid")
    //
    //        do {
    //            try managedContext.save()
    //            return true
    //        } catch let error as NSError {
    //            print("Could not save. \(error), \(error.userInfo)")
    //            return false
    //        }
    //    }
    //
    //    func getGroups() -> [ToDoTask]?{
    //
    //        let managedContext = persistentContainer.viewContext
    //        var lists = [ToDoTask]()
    //        guard let managedTasks = fetchGroupsFromCoreData() else {return nil}
    //
    //        for object in managedTasks{
    //            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
    //            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
    //            guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else {return nil}
    //
    //            let list = ToDoTask(name: name, uuid: uuid as! UUID, toDoTasks: [],items:[],dateCreated: date)
    //            lists.append(list)
    //        }
    //        return lists
    //    }
    //
    //    func fetchGroupsFromCoreData() -> [NSManagedObject]?{
    //        let managedContext = persistentContainer.viewContext
    //        let listsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDList")
    //        var lists : [NSManagedObject] = []
    //        do {
    //            lists = try managedContext.fetch(listsFetch)
    //        } catch let error as NSError {
    //            fatalError("Failed to fetch foods: \(error)")
    //        }
    //        return lists
    //    }
    func saveList(_ taskList: ToDoTask) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TDList", in: managedContext)!
        
        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
        managedTask.setValue(taskList.name, forKeyPath: "name")
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
    func saveListWithGroup(_ list: ToDoTask,_ group: ToDoListGroup) -> Bool? {
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
                    
                    managedList.setValue(list.name, forKeyPath: "name")
                    let uuid = UUID()
                    managedList.setValue(uuid, forKeyPath: "uuid")
                    managedList.setValue(NSDate(), forKeyPath: "dateCreated")
                    
                    mGroup.addToLists(managedList)
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

    func getLists() -> [ToDoTask]?{
        
        let managedContext = persistentContainer.viewContext
        var lists: [ToDoTask]? = []
        guard let managedTasks = coreDataUtil.fetchListsFromCoreData() else {return nil}
        
//        let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDList")
//        listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )

        for object in managedTasks{
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
            guard let dateCreated = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}

            // guard let tasks = (object as AnyObject).value(forKey: "tasks") as? NSDate else{return nil}
            
            if let tasks = (object as AnyObject).value(forKey: "tasks") as? [AnyObject]{
                
                if let tasks = coreDataUtil.tasksFromManagedObject(tasks){
                    
                    if let items = (object as AnyObject).value(forKey: "items") as? [AnyObject]{
                        
                        if let items = coreDataUtil.itemsFromManagedObject(items){
                            let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID, date: dateCreated, items: items, subTasks: tasks)
                            lists?.append(list)
                            
                        }
                    }else{
                        let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID, date:dateCreated, items: [], subTasks: [])
                        lists?.append(list)
                        
                    }
                }
                }else{
                    let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID, date:dateCreated, items: [], subTasks: [])
                    lists?.append(list)
                }
            }
            return lists
        }
    func getListsByGroup(groupID:UUID) -> [ToDoTask]?{
        
        let managedContext = persistentContainer.viewContext
        var lists: [ToDoTask]? = []
        guard let managedGroups = coreDataUtil.fetchGroupListsFromCoreData(groupID: groupID) as? [TDGroup] else {return nil}
        
//        let groupFetch = NSFetchRequest<NSManagedObject>(entityName: "TDGroup")
//        groupFetch.predicate = NSPredicate(format: "%K == %@", "uuid", groupID as any CVarArg )

        for object in managedGroups{
            
           // guard let manlist = object
//            guard let mlists = (object as AnyObject).value(forKey: "lists") as? [TDList] else{
//                return nil
//            }
            if let mlists = object.lists {
                for mlist in mlists{
                    guard let name = (mlist as AnyObject).value(forKey: "name") as? String else{return nil}
                    guard let uuid = (mlist as AnyObject).value(forKey: "uuid") else{return nil}
                    guard let dateCreated = (mlist as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}

                    let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID, date:dateCreated, items: [], subTasks: [])
                    lists?.append(list)

                }
            }

            }
            return lists
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
