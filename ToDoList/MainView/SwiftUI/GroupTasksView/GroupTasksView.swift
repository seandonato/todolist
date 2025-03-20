//
//  GroupTasksView.swift
//  ToDoList
//
//  Created by Sean Donato on 2/1/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct GroupTasksView: View{

    let navigationModel: NavigationModel

    @State var viewModel: GroupTasksViewModelObservable
    @State var project: ToDoListGroup
    @State var tasks: [ToDoTask]
    @State var showPopover: Bool = false

    var body: some View{
        VStack(alignment: .leading,content:{
          
            NTListHeader(headerTitle: "project:", entityName: project.name, subEntityName: "tasks:")

            List{
                ForEach(viewModel.lists ?? []) { task in
                    TaskTableViewCellBasic(action: { status in
                        changeStatus(status, task)
                    }, navigateToDetailAction: { targetTask in
                        navigateToDetail(targetTask)
                    }, task: task)
                    
                }.onDelete(perform: { indexSet in
                    delete(at: indexSet)
                })
                NTAddEntityCell(title: "+ Add Task", showPopover: $showPopover) {
                    AddTaskToGroupSUI(viewModel: viewModel, stringValue: "", isPresented: $showPopover)
                }
            }.listStyle(.plain)
                .padding(EdgeInsets(top: 0.0, leading: 48, bottom: 0.0, trailing: 0.0))

        })
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets{
            if let list = viewModel.lists?[index]{
                viewModel.deleteList(list.uuid)
            }
        }
    }
    func changeStatus(_ status:ToDoTaskStatus,_ task:ToDoTask){
        
        viewModel.changeStatusFor(task, status)
        //viewModel.fetchLists()
    }
    func navigateToDetail(_ targetTask: ToDoTask){
        var model = ToDoListViewModelObservable()
        model.toDoTask = targetTask
        if let container = viewModel.coreDataManager?.persistentContainer{
            model.coreDataManager = CoreDataManager(persistentContainer:container)
            model.fetchData()
            var taskView = TaskView(navigationModel: navigationModel, parentView: project.name, viewModel: model, task: targetTask, tasks: targetTask.subTasks ?? [])
            navigationModel.push{
                taskView
            }
        }
    }
}

