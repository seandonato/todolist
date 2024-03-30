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
    func saveTask(_ task: ToDoTask) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedTask", in: managedContext)!

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
    
    func fetchTasksFromCoreData() -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        let foodsFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")
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
        let tasksFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")

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
        let tasksFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")

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
        let tasksFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")

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

}
