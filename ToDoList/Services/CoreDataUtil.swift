//
//  CoreDataUtil.swift
//  ToDoList
//
//  Created by Sean Donato on 9/24/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataUtil {
    let persistentContainer : NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchListsFromCoreData() -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        let listsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        var lists : [NSManagedObject] = []
        do {
            lists = try managedContext.fetch(listsFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return lists
    }

    
    func fetchGroupListsFromCoreData(groupID:UUID) -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        
        let groupFetch = NSFetchRequest<NSManagedObject>(entityName: "TDGroup")
        groupFetch.predicate = NSPredicate(format: "%K == %@", "uuid", groupID as any CVarArg )

        var groups : [NSManagedObject] = []
        do {
            groups = try managedContext.fetch(groupFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return groups
    }
    func tasksFromManagedObject(_ managedTasks: [AnyObject]) -> [ToDoTask]?{
        var tasks: [ToDoTask] = []
        
        for object in managedTasks{
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
            guard let status = (object as AnyObject).value(forKey: "status") as? String else{return nil}
            guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
            
            var taskStatus = ToDoTaskStatus.ready
            if status == "in progress"{
                taskStatus = ToDoTaskStatus.inProgress
            }else if status == "done"{
                taskStatus = ToDoTaskStatus.done
            }
            if let note = (object as AnyObject).value(forKey: "note") as? String{
                let task = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                tasks.append(task)
            }else{
                let task = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                tasks.append(task)
            }
            
        }
        return tasks
    }
    func itemsFromManagedObject(_ managedItems: [AnyObject]) -> [ToDoItem]?{
        var items: [ToDoItem] = []
        
        for object in managedItems{
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
            guard let quantity = (object as AnyObject).value(forKey: "quantity") as? Int else{return nil}
            guard let brand = (object as AnyObject).value(forKey: "brand") as? String else{return nil}
            guard let date = (object as AnyObject).value(forKey: "date") as? NSDate else{return nil}
            
            let item = ToDoItem(name: name, brand: brand, quantity: quantity, uuid: uuid  as! UUID, date: date)
            items.append(item)
            
        }
        return items
    }

func taskItemsFromManagedObject(_ managedItems: [AnyObject]) -> [ToDoItem]?{
    var items: [ToDoItem] = []
    
    for object in managedItems{
        guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
        guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
        guard let quantity = (object as AnyObject).value(forKey: "quantity") as? Int else{return nil}
        guard let brand = (object as AnyObject).value(forKey: "brand") as? String else{return nil}
        guard let date = (object as AnyObject).value(forKey: "date") as? NSDate else{return nil}
        
        let item = ToDoItem(name: name, brand: brand, quantity: quantity, uuid: uuid  as! UUID, date: date)
        items.append(item)
        
    }
    return items
}
//    func taskFromManagedObject(_ managedTask: TDTask) -> ToDoTask?{
//
//            guard let name = managedTask.value(forKey: "name") as? String else{return nil}
//            guard let uuid = managedTask.value(forKey: "uuid") as? UUID else{return nil}
//            guard let date = managedTask.value(forKey: "dateCreated") as? NSDate else{return nil}
//            
//        var itemArray = [ToDoItem]()
//        if let items = managedTask.items {
//            for item in items{
//                guard let itemName = (item as AnyObject).value(forKey: "name") as? String else{return nil}
//                guard let uuid = (item as AnyObject).value(forKey: "uuid") else {return nil}
//                //guard let quantity = (object as AnyObject).value(forKey: "quantity") as? NSNumber else{return nil}
//
//                let item = ToDoItem(name: itemName, brand: "brand", quantity: 1, uuid: uuid  as! UUID, date: NSDate())
//                itemArray.append(item)
//
//            }
//                let task = ToDoTask(name: name, uuid: uuid, date: date,items: itemArray)
//                return task
//
//
//        }
//
        //new function
        func taskFromManagedObject(_ managedTask: TDTask) -> ToDoTask?{

            guard let name = managedTask.value(forKey: "name") as? String else{return nil}
            guard let uuid = managedTask.value(forKey: "uuid") as? UUID else{return nil}
            guard let date = managedTask.value(forKey: "dateCreated") as? NSDate else{return nil}
                
            var itemArray = [ToDoItem]()
            if let items = managedTask.items {
                for item in items{
                    guard let itemName = (item as AnyObject).value(forKey: "name") as? String else{return nil}
                    guard let uuid = (item as AnyObject).value(forKey: "uuid") else {return nil}
                    //guard let quantity = (object as AnyObject).value(forKey: "quantity") as? NSNumber else{return nil}

                    let item = ToDoItem(name: itemName, brand: "brand", quantity: 1, uuid: uuid  as! UUID, date: NSDate())
                    itemArray.append(item)

                }
                    let task = ToDoTask(id: uuid as! UUID,name: name, uuid: uuid, date: date,items: itemArray)
                    return task

            }
            

    return nil
    
}

}
