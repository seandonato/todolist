//
//  TaskListRepresentable.swift
//  ToDoList
//
//  Created by Sean Donato on 12/28/24.
//

import Foundation
import UIKit
import SwiftUI

@available(iOS 17.0, *)
class TaskListHostingController: UIViewController,ToDoListViewModelDelegate{
    private let navigationModel = NavigationModel()

    func didFinishFetchingData() {
        tasks = viewModel.tasks ?? []
        setupHostingVC()
    }
    
//    var hostingController: UIHostingController<TaskList>?
    var hostingController: UIHostingController<TaskView>?
    var tasks: [ToDoTask] = []
    let viewModel: ToDoListViewModelObservable
    
    init(viewModel:ToDoListViewModelObservable){
        
        self.viewModel = viewModel
        //hostingController = UIHostingController(rootView: TaskList(viewModel: viewModel, tasks: viewModel.tasks ?? []))

        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        viewModel.toDoListViewModelDelegate = self
        viewModel.fetchData()
    }
        
    func setupHostingVC(){
        navigationModel.navigationController = self.navigationController
        if let task = viewModel.list{
            hostingController = UIHostingController(rootView: TaskView(navigationModel: self.navigationModel, viewModel: viewModel, task: task , tasks: tasks ?? []))
            

            guard let hostingController = hostingController else{return}
            hostingController.sizingOptions = .intrinsicContentSize

            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(hostingController.view)
    //
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

            ])

        }
        

        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //var hostingController: UIHostingController
}
//class ListVCHost : UIHostingController<ListVCHost.MyView> {
//    var tasks: [ToDoTask] = []
//    let viewModel: ToDoListViewModel
//
//    // Internal view
//    struct MyView: View {
//      var body: some View {
//          TaskList(viewModel: viewModel, tasks: tasks ?? [])
//      }
//    }
//
////    weak var coordinator: MainCoordinator?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder, rootView: MyView())
//    }
//}
