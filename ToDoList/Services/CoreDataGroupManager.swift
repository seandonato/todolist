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
    func saveGroup(_ taskGroup: ToDoTaskList) -> Bool? {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TDTaskList", in: managedContext)!
        
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
    
    func getGroups() -> [ToDoTaskList]?{
        
        let managedContext = persistentContainer.viewContext
        var lists = [ToDoTaskList]()
        guard let managedTasks = fetchGroupsFromCoreData() else {return nil}
        
        for object in managedTasks{
            guard let name = (object as AnyObject).value(forKey: "name") as? String else{return nil}
            guard let uuid = (object as AnyObject).value(forKey: "uuid") else{return nil}
            
            let list = ToDoTaskList(name: name, uuid: uuid as! UUID, toDoTasks: [])
            lists.append(list)
        }
        return lists
    }
    
    func fetchGroupsFromCoreData() -> [NSManagedObject]?{
        let managedContext = persistentContainer.viewContext
        let listsFetch = NSFetchRequest<NSManagedObject>(entityName: "TDTaskList")
        var lists : [NSManagedObject] = []
        do {
            lists = try managedContext.fetch(listsFetch)
        } catch let error as NSError {
            fatalError("Failed to fetch foods: \(error)")
        }
        return lists
    }
}
