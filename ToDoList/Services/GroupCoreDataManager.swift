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
//    func saveGroup(_ taskGroup: ToDoTaskList) -> Bool? {
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
//    func getGroups() -> [ToDoTaskList]?{
//        
//        let managedContext = persistentContainer.viewContext
//        var lists = [ToDoTaskList]()
//        guard let managedTasks = fetchGroupsFromCoreData() else {return nil}
//        
//        for object in managedTasks{
//            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
//            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
//            guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else {return nil}
//
//            let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: [],items:[],dateCreated: date)
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
    func saveGroup(_ group: ToDoListGroup) -> Bool? {
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
    
    func getGroups() -> [ToDoListGroup]?{
        
        let managedContext = persistentContainer.viewContext
        var groups = [ToDoListGroup]()
        guard let managedGroups = fetchGroupsFromCoreData() else {return nil}
        
        for object in managedGroups{
           
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}

            var lists: [ToDoTask] = []
            if let tdlists = (object as AnyObject).value(forKey: "lists") as? [TDTask] {
                for list in tdlists
                {
                    guard let name = (list as AnyObject).value(forKey: "name") as? String else{return nil}
                    guard let uuid = (list as AnyObject).value(forKey: "uuid") as? UUID else{return nil}
                    guard let date = (list as AnyObject).value(forKey: "date") as? NSDate else{return nil}
                    let list = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid, date: date, items: [], subTasks: [])
                    //guard let items = object
                }

            }

            print(lists)
            let group = ToDoListGroup(name: name, uuid: uuid as! UUID,lists: lists)
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
