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
    func saveTask(_ task: Task) -> Bool? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedTask", in: managedContext)!

        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
        managedTask.setValue(task.name, forKeyPath: "name")
        var uuid = UUID()
        managedTask.setValue(uuid.description, forKeyPath: "uuid")
        managedTask.setValue("ready", forKeyPath: "status")
        //managedTask.setValue("", forKeyPath: "uuid")

        do {
          try managedContext.save()
            return true
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
            return false
        }

        return true
                
    }
    
    func getTasks() -> [Task]?{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return [Task]()
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedTask", in: managedContext)!
        var tasks = [Task]()
        guard let managedTasks = fetchTasksFromCoreData() else {return nil}
        
        for object in managedTasks{
            if let name = (object as AnyObject).value(forKey: "name") as? String{
                if let uuid = (object as AnyObject).value(forKey: "uuid"){
                    if let status = (object as AnyObject).value(forKey: "status") as? String{
                        var taskStatus = TaskStatus.ready
                        if status == "in progress"{
                            taskStatus = TaskStatus.inProgress
                        }else if status == "done"{
                            taskStatus = TaskStatus.done

                        }
                        if let note = (object as AnyObject).value(forKey: "note") as? String{
                            
                            let task = Task(name: name, uuid: uuid as? String ?? "", status: status,taskStatus: taskStatus, note: note)
                            tasks.append(task)

                        }else{
                            let task = Task(name: name, uuid: uuid as! String, status: status,taskStatus: taskStatus)
                            tasks.append(task)
                        }
                    }
                }
           }
        }
        return tasks
    }
    
    func fetchTasksFromCoreData() -> [NSManagedObject]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let foodsFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")
        var tasks : [NSManagedObject] = []
        do {
            tasks = try managedContext.fetch(foodsFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return tasks
    }
    enum CoreDataError: Error {
        case NoAppDelegate
        case FailedToUpdate
    }
    func updateTaskStatus(_ task: Task,_ status: TaskStatus,completion: @escaping ((Result<Bool,Error>) -> ())) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(CoreDataError.NoAppDelegate))
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let taskID = task.uuid
        let foodsFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")

        foodsFetch.predicate = NSPredicate(format: "uuid == %@", taskID as CVarArg)

        do{
             let fetchResults = try managedContext.fetch(foodsFetch)
            
                if fetchResults.count != 0{
                    
                    var managedObject = fetchResults[0]
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
    
    func deleteTask(_ task: Task) -> Bool? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let taskID = task.uuid
        let foodsFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")

        foodsFetch.predicate = NSPredicate(format: "uuid == %@", taskID as CVarArg)

        do{
             let fetchResults = try managedContext.fetch(foodsFetch)
            
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
            
        }

        return true
                
    }
    func updateTaskNotes(_ task: Task,_ note: String) -> Bool? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let taskID = task.uuid
        let foodsFetch = NSFetchRequest<NSManagedObject>(entityName: "ManagedTask")

        foodsFetch.predicate = NSPredicate(format: "uuid == %@", taskID as CVarArg)

        do{
             let fetchResults = try managedContext.fetch(foodsFetch)
            
                if fetchResults.count != 0{
                    
                    var managedObject = fetchResults[0]
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
