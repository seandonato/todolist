//
//  SceneDelegate.swift
//  ToDoList-MVC
//
//  Created by Sean Donato on 3/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = self.window ?? UIWindow()

        //check if its first run, if so, open dialog to create first, if not: fetch primary group and tasks
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            let coreDataService = CoreDataService(containerName: "TaskModel")
            let coreDataManager = CoreDataManager(persistentContainer: coreDataService.persistentContainer)
            let toDoListViewModel = ToDoListViewModel()
            toDoListViewModel.lists = coreDataManager.getLists()
            if let lists = toDoListViewModel.lists{
                toDoListViewModel.list = lists[0]
            }
            toDoListViewModel.coreDataManager = coreDataManager
            
            let nav = UINavigationController(rootViewController: ToDoListViewController(toDoListViewModel))
            self.window!.rootViewController = nav

            self.window!.makeKeyAndVisible()
            guard scene is UIWindowScene else { return }
            guard let _ = (scene as? UIWindowScene) else { return }

        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let coreDataService = CoreDataService(containerName: "TaskModel")
            let coreDataManager = CoreDataManager(persistentContainer: coreDataService.persistentContainer)
            let toDoListViewModel = ToDoListViewModel()
            toDoListViewModel.coreDataManager = coreDataManager
            
            let nav = UINavigationController(rootViewController: AddListViewController(toDoListViewModel))
            self.window!.rootViewController = nav

            self.window!.makeKeyAndVisible()
            guard scene is UIWindowScene else { return }
            guard let _ = (scene as? UIWindowScene) else { return }

        }

        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

