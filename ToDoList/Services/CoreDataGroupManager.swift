//
//  CoreDataGroupManager.swift
//  ToDoList
//
//  Created by Sean Donato on 4/17/24.
//

import Foundation
import CoreData

class CoreDataGroupManager {
    
    let persistentContainer : NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    func saveGroup(_ taskGroup: ToDoTaskGroup) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedTaskGroup", in: managedContext)!
        
        let managedTask = NSManagedObject(entity: entity, insertInto: managedContext)
        managedTask.setValue(taskGroup.name, forKeyPath: "name")
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
}
