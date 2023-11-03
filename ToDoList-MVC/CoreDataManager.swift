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
        var uuid = NSUUID()
        managedTask.setValue(uuid, forKeyPath: "uuid")
        managedTask.setValue("ready", forKeyPath: "status")

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
                        
                        let task = Task(name: name, uuid: uuid as! UUID, status: status)
                        tasks.append(task)
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
}
