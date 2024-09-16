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
    
    func saveTaskWithList(_ task: ToDoTask,_ list: ToDoTaskList) -> Bool? {
        let managedContext = persistentContainer.viewContext
        
        //get list
        print(task.name)
        let listID = list.uuid
        let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDList")
        listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
        do{
            let fetchResults = try managedContext.fetch(listFetch)
            if !fetchResults.isEmpty{
                
                let managedList = fetchResults[0]
                
                if let mList = fetchResults[0] as? TDList{
                    
                    print("suck")
                    let entity = NSEntityDescription.entity(forEntityName: "TDTask", in: managedContext)!
                    
                    let managedTask = TDTask(entity: entity, insertInto: managedContext)
                    
                    managedTask.setValue(task.name, forKeyPath: "name")
                    let uuid = UUID()
                    managedTask.setValue(uuid, forKeyPath: "uuid")
                    managedTask.setValue("ready", forKeyPath: "status")
                    managedTask.setValue(NSDate(), forKeyPath: "dateCreated")
                    
                    mList.addToTasks(managedTask)
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
    
    func getTasks() -> [ToDoTask]?{
        
        let managedContext = persistentContainer.viewContext
        var tasks = [ToDoTask]()
        guard let managedTasks = fetchTasksFromCoreData() else {return nil}
        
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
            }else if status == "blocked"{
                taskStatus = ToDoTaskStatus.blocked
            }
            if let note = (object as AnyObject).value(forKey: "note") as? String{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                tasks.append(task)
            }else{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                tasks.append(task)
            }
            
            if let items = (object as AnyObject).value(forKey: "items") as? [ToDoItem]{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: "",date: date,items: items)
                tasks.append(task)
            }else{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                tasks.append(task)
            }

        }
        return tasks
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
    
    func fetchListsFromCoreData() -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        let listsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDList")
        var lists : [NSManagedObject] = []
        do {
            lists = try managedContext.fetch(listsFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return lists
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
                    //print("Could not save. \(error), \(error.userInfo)")
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
    
    //lists
    func saveList(_ taskList: ToDoTaskList) -> Bool? {
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
    
    func getLists() -> [ToDoTaskList]?{
        
        let managedContext = persistentContainer.viewContext
        var lists: [ToDoTaskList]? = []
        guard let managedTasks = fetchListsFromCoreData() else {return nil}
        
        for object in managedTasks{
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
            // guard let tasks = (object as AnyObject).value(forKey: "tasks") as? NSDate else{return nil}
            
            if let tasks = (object as AnyObject).value(forKey: "tasks") as? [AnyObject]{
                
                if let tasks = tasksFromManagedObject(tasks){
                    let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: tasks)
                    lists?.append(list)
                }else{
                    let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: [])
                    lists?.append(list)

                }
            }else{
                let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: [])
                lists?.append(list)
            }
        }
        return lists
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
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                tasks.append(task)
            }else{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                tasks.append(task)
            }
            if let items = (object as AnyObject).value(forKey: "items") as? [ToDoItem]{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: "",date: date,items: items)
                tasks.append(task)
            }else{
                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                tasks.append(task)
            }

        }
        return tasks
    }
    func getList() -> ToDoTaskList?{
        
        let managedContext = persistentContainer.viewContext
        var list: ToDoTaskList?
        
        guard let managedLists = fetchListsFromCoreData() else {return nil}
        
        if managedLists.count > 0 {
            if let mList = managedLists[0] as? TDTaskList{
                
//                guard let name = (mList as AnyObject).value(forKey: "name") as? String else{return nil}
//                guard let uuid = (mList as AnyObject).value(forKey: "uuid") else{return nil}
//                guard let mTasks = (mList as AnyObject).value(forKey: "tasks")  else{return nil}

                var tasks: [ToDoTask] = []
                
                
                if let c = mList.tasks{
                    for object in c
                     {
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
                            let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                            tasks.append(task)
                        }else{
                            let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                            tasks.append(task)
                        }
                        if let items = (object as AnyObject).value(forKey: "items") as? [ToDoItem]{
                            let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: "",date: date,items: items)
                            tasks.append(task)
                        }else{
                            let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                            tasks.append(task)
                        }
                    }

                    list = ToDoTaskList(name: mList.name ?? "", uuid: mList.uuid as! UUID, toDoTasks: tasks)

                }

            }
        
        }
//        for object in managedTasks{
//            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
//            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
//            guard let status = (object as AnyObject).value(forKey: "status") as? String else{return nil}
//            guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
//
//            var taskStatus = ToDoTaskStatus.ready
//            if status == "in progress"{
//                taskStatus = ToDoTaskStatus.inProgress
//            }else if status == "done"{
//                taskStatus = ToDoTaskStatus.done
//            }
//            if let note = (object as AnyObject).value(forKey: "note") as? String{
//                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
//                //tasks.append(task)
//            }else{
//                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
//                //tasks.append(task)
//            }
//        }
        return list
    }
    func getList2(listID: UUID) -> ToDoTaskList?{
        
        var list: ToDoTaskList = ToDoTaskList(name: "", uuid: listID, toDoTasks: [])
        let managedContext = persistentContainer.viewContext

        let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTaskList")
        listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
        do{
            
            let fetchResults = try managedContext.fetch(listFetch)
            if !fetchResults.isEmpty{
                
                let managedList = fetchResults[0]
                
                if let mList = fetchResults[0] as? TDTaskList{
                    
                    if let items = (object as AnyObject).value(forKey: "items") as? [AnyObject]{
                        
                        if let items = itemsFromManagedObject(items){
                            let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: tasks,items: items)
                            lists?.append(list)
                            
                        }
                    }else{
                        let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: [],items: [])
                        lists?.append(list)
                        
                    }
                }
                }else{
                    let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: [],items: [])
                    lists?.append(list)
                }
            }
            return lists
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
                    let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                    tasks.append(task)
                }else{
                    let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
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
        
        //    func getList() -> ToDoTaskList?{
        //
        //        let managedContext = persistentContainer.viewContext
        //        var list: ToDoTaskList?
        //
        //        guard let managedLists = fetchListsFromCoreData() else {return nil}
        //
        //        if managedLists.count > 0 {
        //            if let mList = managedLists[0] as? TDList{
        //
        ////                guard let name = (mList as AnyObject).value(forKey: "name") as? String else{return nil}
        ////                guard let uuid = (mList as AnyObject).value(forKey: "uuid") else{return nil}
        ////                guard let mTasks = (mList as AnyObject).value(forKey: "tasks")  else{return nil}
        //
        //                var tasks: [ToDoTask] = []
        //
        //
        //                if let c = mList.tasks{
        //                    for object in c
        //                     {
        //                        guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
        //                        guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
        //                        guard let status = (object as AnyObject).value(forKey: "status") as? String else{return nil}
        //                        guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
        //
        //                        var taskStatus = ToDoTaskStatus.ready
        //                        if status == "in progress"{
        //                            taskStatus = ToDoTaskStatus.inProgress
        //                        }else if status == "done"{
        //                            taskStatus = ToDoTaskStatus.done
        //                        }
        //                        if let note = (object as AnyObject).value(forKey: "note") as? String{
        //                            let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
        //                            tasks.append(task)
        //                        }else{
        //                            let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
        //                            tasks.append(task)
        //                        }
        //                    }
        //
        //                    list = ToDoTaskList(name: mList.name ?? "", uuid: mList.uuid as! UUID, toDoTasks: tasks)
        //
        //                }
        //
        //            }
        //
        //        }
        ////        for object in managedTasks{
        ////            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
        ////            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
        ////            guard let status = (object as AnyObject).value(forKey: "status") as? String else{return nil}
        ////            guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
        ////
        ////            var taskStatus = ToDoTaskStatus.ready
        ////            if status == "in progress"{
        ////                taskStatus = ToDoTaskStatus.inProgress
        ////            }else if status == "done"{
        ////                taskStatus = ToDoTaskStatus.done
        ////            }
        ////            if let note = (object as AnyObject).value(forKey: "note") as? String{
        ////                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
        ////                //tasks.append(task)
        ////            }else{
        ////                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
        ////                //tasks.append(task)
        ////            }
        ////        }
        //        return list
        //    }
        func getList2(listID: UUID) -> ToDoTaskList?{
            
            var list: ToDoTaskList = ToDoTaskList(name: "", uuid: listID, toDoTasks: [],items: [])
            let managedContext = persistentContainer.viewContext
            
            let listFetch = NSFetchRequest<NSManagedObject>(entityName: "TDList")
            listFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
            do{
                
                let fetchResults = try managedContext.fetch(listFetch)
                if !fetchResults.isEmpty{
                    
                    let managedList = fetchResults[0]
                    
                    if let mList = fetchResults[0] as? TDList{
                        
                        var tasks: [ToDoTask] = []
                        
                        var items: [ToDoItem] = []
                        
                        if let c = mList.tasks{
                            for object in c
                            {
                                guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
                                guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
                                guard let status = (object as AnyObject).value(forKey: "status") as? String else{return nil}
                                guard let date = (object as AnyObject).value(forKey: "dateCreated") as? NSDate else{return nil}
                                
                                var taskStatus = ToDoTaskStatus.ready
                                if status == "in progress"{
                                    taskStatus = ToDoTaskStatus.inProgress
                                }else if status == "done"{
                                    taskStatus = ToDoTaskStatus.done
                                }else if status == "blocked"{
                                    taskStatus = ToDoTaskStatus.blocked
                                }
                                //                            if let note = (object as AnyObject).value(forKey: "note") as? String{
                                //                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
                                //                                tasks.append(task)
                                //                            }else{
                                //                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
                                //                                tasks.append(task)
                            }
//                            if let note = (object as AnyObject).value(forKey: "note") as? String{
//                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: note,date: date)
//                                tasks.append(task)
//                            }else{
//                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
//                                tasks.append(task)
//                            }
                            var todoItems = [ToDoItem]()
                            if let task = object as? TDTask{

                                if let items = task.items{
                                    for item in items{
                                        guard let name = (item as AnyObject).value(forKey: "name") as? String else{return nil}
                                        guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
                                        guard let brand = (item as AnyObject).value(forKey: "brand") as? String else{return nil}
                                        guard let acquired = (item as AnyObject).value(forKey: "acquired") as? Bool else{return nil}
                                        guard let quantity = (item as AnyObject).value(forKey: "quantity") as? Int else{return nil}

                                        var toDoItem = ToDoItem(name: name, brand: "", quantity: quantity, uuid: uuid as! UUID, date: NSDate())
                                        todoItems.append(toDoItem)
                                    }
                                }
                            }
                           
                            
//                            if let tdItems = todoItems{
                                
                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus, note: "",date: date,items: todoItems)
                                tasks.append(task)
//                            }else{
//                                let task = ToDoTask(name: name, uuid: uuid as! UUID ,taskStatus: taskStatus,date:date)
//                                tasks.append(task)
//                            }
                        }
                        
                        
                        list = ToDoTaskList(name: mList.name ?? "", uuid: mList.uuid!, toDoTasks: tasks,items: items)
                        
                    }
                    
                }
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return nil
            }
            
            
            return list
        }
        
        // MARK: Items
        func saveItemToTask(_ item: ToDoTaskItem,_ task: ToDoTask) -> Bool? {
            let managedContext = persistentContainer.viewContext
            
            //get list
            print(task.name)
            let taskID = task.uuid
            let taskFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTask")
            taskFetch.predicate = NSPredicate(format: "%K == %@", "uuid", taskID as any CVarArg )
            do{
                let fetchResults = try managedContext.fetch(taskFetch)
                if !fetchResults.isEmpty{
                    
                    let entity = NSEntityDescription.entity(forEntityName: "TDItem", in: managedContext)!

                    let managedItem = TDItem(entity: entity, insertInto: managedContext)
                    
                    managedItem.setValue(item.name, forKeyPath: "name")
                    managedItem.setValue(item.brand, forKeyPath: "brand")

                    let uuid = UUID()
                    managedItem.setValue(uuid, forKeyPath: "uuid")
                    managedItem.setValue(item.quantity, forKeyPath: "quantity")
                    managedItem.setValue(false, forKeyPath: "acquired")
//                    managedItem.setValue(NSDate(), forKeyPath: "dateCreated")
                    
                    mTask.addToItems(managedItem)
                    do {
                      try managedContext.save()
                        return true
                    } catch let error as NSError {
                      print("Could not save. \(error), \(error.userInfo)")
                        return false
                    }
                    print(fetchResults)
                }
            }catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return false
            }
            return false
        }
        
        func saveItemToList(_ item: ToDoItem,_ list: ToDoTaskList) -> Bool? {
            let managedContext = persistentContainer.viewContext
            
            //get list
            print(list.name)
            let listID = list.uuid
            let taskFetch = NSFetchRequest<NSManagedObject>(entityName: "TDList")
            taskFetch.predicate = NSPredicate(format: "%K == %@", "uuid", listID as any CVarArg )
            do{
                let fetchResults = try managedContext.fetch(taskFetch)
                if !fetchResults.isEmpty{
                    
                    let managedList = fetchResults[0]
                    
                    if let mList = fetchResults[0] as? TDList{
                        
                        let entity = NSEntityDescription.entity(forEntityName: "TDItem", in: managedContext)!
                        
                        let managedItem = TDItem(entity: entity, insertInto: managedContext)
                        
                        managedItem.setValue(item.name, forKeyPath: "name")
                        let uuid = UUID()
                        managedItem.setValue(uuid, forKeyPath: "uuid")
                        managedItem.setValue(false, forKeyPath: "acquired")
//                        managedItem.setValue(NSDate(), forKeyPath: "dateCreated")
                        mList.addToItems(managedItem)
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
        
    }

