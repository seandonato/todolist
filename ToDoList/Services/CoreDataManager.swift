//
//  CoreDataManager.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    let persistentContainer : NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    //new
    func saveTaskWithParent(_ task: ToDoTask,_ parent: ToDoTask) -> Bool? {
        let managedContext = persistentContainer.viewContext
        
        //get list
        print(task.name)
        let listID = parent.uuid
        let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
        do{
            let fetchResults = try managedContext.fetch(listFetch)
            if !fetchResults.isEmpty{
                
                let managedList = fetchResults[0]
                
                if let mList = fetchResults[0] as? TDTask{
                    
                    print("save task")
                    let entity = NSEntityDescription.entity(forEntityName: "TDTask", in: managedContext)!
                    
                    let managedTask = TDTask(entity: entity, insertInto: managedContext)
                    
                    managedTask.setValue(task.name, forKeyPath: "name")
                    let uuid = UUID()
                    managedTask.setValue(uuid, forKeyPath: "uuid")
                    managedTask.setValue("ready", forKeyPath: "status")
                    managedTask.setValue(NSDate(), forKeyPath: "dateCreated")
                    
                    //managedTask.setValue(task.name, forKeyPath: "name")

                    mList.addToSubTasks(managedTask)
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

    func updateList(){
        
    }
    func saveTask(_ task: ToDoTask) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TDTask", in: managedContext)!
        
        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
        managedTask.setValue(task.name, forKeyPath: "name")
        let uuid = UUID()
        managedTask.setValue(uuid, forKeyPath: "uuid")
        managedTask.setValue("ready", forKeyPath: "status")
        managedTask.setValue(NSDate(), forKeyPath: "dateCreated")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
    }
    
    
    func fetchTasksFromCoreData() -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        let foodsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        var tasks : [NSManagedObject] = []
        do {
            tasks = try managedContext.fetch(foodsFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return tasks
    }
    
    func updateTaskStatus(_ task: ToDoTask,_ status: ToDoTaskStatus,completion: @escaping ((Result<Bool,Error>) -> ())) {
        
        print(task.name)
        let managedContext = persistentContainer.viewContext
        let taskID = task.uuid
        let tasksFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        
        //foodsFetch.predicate = NSPredicate(format: "uuid == %@", taskID as CVarArg)
        // Make a predicate asking only for sessions of a certain "projectId"
        tasksFetch.predicate = NSPredicate(format: "%K == %@", "uuid", taskID as any CVarArg )
        
        do{
            
            let fetchResults = try managedContext.fetch(tasksFetch)
            
            if fetchResults.count != 0{
                
                let managedObject = fetchResults[0]
                switch status{
                case .blocked:
                    managedObject.setValue("blocked", forKey: "status")
                case .done:
                    managedObject.setValue("done", forKey: "status")
                case .inProgress:
                    managedObject.setValue("in progress", forKey: "status")
                case .ready:
                    managedObject.setValue("ready", forKey: "status")
                }
                do {
                    try managedContext.save()
                    completion(.success(true))
                } catch let error as NSError {
                    completion(.failure(error))
                }
            }
        }catch{
            
        }
        
    }
    
    func deleteTask(_ task: ToDoTask) -> Bool? {
        
        let managedContext = persistentContainer.viewContext
        let taskID = task.uuid
        let tasksFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        
        tasksFetch.predicate = NSPredicate(format: "%K == %@", "uuid", taskID as any CVarArg )
        
        do{
            let fetchResults = try managedContext.fetch(tasksFetch)
            
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
    
    func deleteItem(_ item: ToDoItem) -> Bool? {
        
        let managedContext = persistentContainer.viewContext
        let itemID = item.uuid
        let itemsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDItem")
        
        itemsFetch.predicate = NSPredicate(format: "%K == %@", "uuid", itemID as any CVarArg)
        
        do{
            let fetchResults = try managedContext.fetch(itemsFetch)
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
    
    func deleteTaskItem(_ item: ToDoItem) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let itemID = item.uuid
        let itemsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDItem")
        
        itemsFetch.predicate = NSPredicate(format: "%K == %@", "uuid", itemID as any CVarArg )
        
        do{
            let fetchResults = try managedContext.fetch(itemsFetch)
            
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

    func updateTaskNotes(_ task: ToDoTask,_ note: String) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let taskID = task.uuid
        let tasksFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        
        tasksFetch.predicate = NSPredicate(format: "%K == %@", "uuid", taskID as any CVarArg )
        
        do{
            let fetchResults = try managedContext.fetch(tasksFetch)
            
            if fetchResults.count != 0{
                
                let managedObject = fetchResults[0]
                managedObject.setValue(note, forKey: "note")
            }
            do {
                try managedContext.save()
                return true
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return false
            }
        }catch{
            
        }
        return true
    }
    
    //new save parent task
    func saveList(_ taskList: ToDoTask) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TDTask", in: managedContext)!
        
        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
        managedTask.setValue(taskList.name, forKeyPath: "name")
        let uuid = UUID()
        managedTask.setValue(uuid, forKeyPath: "uuid")
        managedTask.setValue(NSDate(), forKeyPath: "dateCreated")

        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }


    //updated for list deprecation
    func getList2(listID: UUID) -> ToDoTask?{
        
        var list: ToDoTask = ToDoTask(id: UUID(),name: "", uuid: listID, date: NSDate())

        let managedContext = persistentContainer.viewContext
        
        let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
        do{
            
            let fetchResults = try managedContext.fetch(listFetch)
            if !fetchResults.isEmpty{
                
                let managedList = fetchResults[0]
                
                if let mList = fetchResults[0] as? TDTask{
                    
                    var tasks: [ToDoTask] = []
                    
                    var items: [ToDoItem] = []
                    
                    if let c = mList.subTasks{
                        for object in c
                        {
                            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
                            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
                            guard let status = (object as AnyObject).value(forKey: "status") as? String else{return nil}
                            guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
                            //guard let items = object
                            
                            var taskStatus = ToDoTaskStatus.ready
                            if status == "in progress"{
                                taskStatus = ToDoTaskStatus.inProgress
                            }else if status == "done"{
                                taskStatus = ToDoTaskStatus.done
                            }else if status == "blocked"{
                                taskStatus = ToDoTaskStatus.blocked
                            }
                            var itemArray = [ToDoItem]()
                            
                            
                            //MARK: fetch task to get items
                            let taskFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
                            taskFetch.predicate = NSPredicate(format: "%K == %@", "uuid", uuid as! any CVarArg  )
                            
                            do{
                                
                                let taskFetchResults = try managedContext.fetch(taskFetch)
                                if !taskFetchResults.isEmpty{
                                    
                                    let managedTask = taskFetchResults[0]
                                    
                                    if let mTask = taskFetchResults[0] as? TDTask{
                                        if let items = mTask.items {
                                            for item in items{
                                                guard let itemName = (item as AnyObject).value(forKey: "name") as? String else{return nil}
                                                guard let uuid = (item as AnyObject).value(forKey: "uuid") else {return nil}
                                                //guard let quantity = (object as AnyObject).value(forKey: "quantity") as? NSNumber else{return nil}

                                                let item = ToDoItem(name: itemName, brand: "brand", quantity: 1, uuid: uuid  as! UUID, date: NSDate())
                                                itemArray.append(item)

                                            }
                                        }
                                    }
                                }
                            }catch{
                                        
                            }
                          

                            if let note = (object as AnyObject).value(forKey: "note") as? String{
                                let task = ToDoTask(id:uuid as! UUID,name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date,items: itemArray)
                                tasks.append(task)
                            }else{
                                let task = ToDoTask(id:uuid as! UUID,name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date,items: itemArray)
                                tasks.append(task)
                            }
                        }
                    }
                    if let i = mList.items{
                        for object in i
                        {
                            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
                            guard let uuid = (object as AnyObject).value(forKey: "uuid") else {return nil}
                            guard let quantity = (object as AnyObject).value(forKey: "quantity") as? NSNumber else{return nil}
//                                guard let brand = (object as AnyObject).value(forKey: "brand") as? String else{return nil}
                            //guard let date = (object as AnyObject).value(forKey: "date") as? NSDate else{return nil}
                            
                            let item = ToDoItem(name: name, brand: "brand", quantity: quantity.intValue, uuid: uuid  as! UUID, date: NSDate())
                            items.append(item)
                            
                            //                            if let note = (object as AnyObject).value(forKey: "note") as? String{
                            //                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                            //                                tasks.append(task)
                            //                            }else{
                            //                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                            //                                tasks.append(task)
                        }
                    }
                    
                    
//                    list = ToDoTask(name: mList.name ?? "", uuid: mList.uuid!, toDoTasks: tasks,items: items, date: mList.dateCreated! as NSDate,dateCreated: mList.dateCreated! as NSDate)
                    list = ToDoTask(id:mList.uuid!,name: mList.name ?? "", uuid: mList.uuid!, date: mList.dateCreated! as NSDate,items: items,subTasks: tasks)
                }
                
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
        list.subTasks = list.subTasks?.sorted( by: {($0.date as Date) < ($1.date as Date)})
        return list
    }

//
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
                    let task = ToDoTask(id:uuid as! UUID,name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                    tasks.append(task)
                }else{
                    let task = ToDoTask(id:uuid as! UUID,name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
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
            let task = ToDoTask(id:uuid,name: name, uuid: uuid, date: date,items: itemArray)
                return task

        }
        
        return nil
        
    }
    
        // MARK: Items
    func saveItemToTask(_ item: ToDoItem,_ task: ToDoTask) -> Bool? {
        let managedContext = persistentContainer.viewContext
        
        //get list
        print(task.name)
        let taskID = task.uuid
        let taskFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        taskFetch.predicate = NSPredicate(format: "%K == %@", "uuid", taskID as any CVarArg )
        do{
            let fetchResults = try managedContext.fetch(taskFetch)
            if !fetchResults.isEmpty{
                
                let managedTask = fetchResults[0]
                
                if let mTask = fetchResults[0] as? TDTask{
                    
                    print("suck")
                    let entity = NSEntityDescription.entity(forEntityName: "TDItem", in: managedContext)!
                    
                    let managedItem = TDItem(entity: entity, insertInto: managedContext)
                    
                    managedItem.setValue(item.name, forKeyPath: "name")
                    let uuid = UUID()
                    managedItem.setValue(uuid, forKeyPath: "uuid")
                    managedItem.setValue(false, forKeyPath: "acquired")
//                        managedItem.setValue(NSDate(), forKeyPath: "dateCreated")
                    mTask.addToItems(managedItem)
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


    
    func fetchTask(task:ToDoTask) -> ToDoTask?{
        let managedContext = persistentContainer.viewContext
        
        let taskFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        taskFetch.predicate = NSPredicate(format: "%K == %@", "uuid", task.uuid as any CVarArg )
        do{
            
            let fetchResults = try managedContext.fetch(taskFetch)
            if !fetchResults.isEmpty{
                
                if let managedTask = fetchResults[0] as? TDTask{
                    if let toDotask = taskFromManagedObject(managedTask){
                        return toDotask
                    }
                    
                }
            }
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
        return nil

    }
        
    func fetchTask(task:ToDoTask,completion: @escaping ((Result<ToDoTask,Error>) -> ())){
        let managedContext = persistentContainer.viewContext
        
        let taskFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
        taskFetch.predicate = NSPredicate(format: "%K == %@", "uuid", task.uuid as any CVarArg )
        do{
            
            let fetchResults = try managedContext.fetch(taskFetch)
            if !fetchResults.isEmpty{
                
                if let managedTask = fetchResults[0] as? TDTask{
                    if let toDotask = taskFromManagedObject(managedTask){
                        completion(.success(toDotask))
                    }
                    
                }
            }
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(.failure(NSError()))
           // return nil
        }
       // return nil

    }

}

