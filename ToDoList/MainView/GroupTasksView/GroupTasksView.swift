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
            VStack(alignment: .leading, spacing:12, content: {
                Text(verbatim: "Group name:")
                Text(verbatim: project.name)
                Text(verbatim: "tasks:")

            })

            List{
                ForEach(viewModel.lists ?? []) { task in
                    TaskTableViewCellBasic(action: { status in
                        changeStatus(status, task)
                    }, navigateToDetailAction: { targetTask in
                        navigateToDetail(targetTask)
                    }, task: task)

                    }
            }.listStyle(.plain)
            })
        HStack{
            Spacer()
            Button("Add Sub Task") {
                showPopover = true
            }
            .popover(isPresented: self.$showPopover,
                             attachmentAnchor: .rect(.rect(CGRect(x: 0, y: 20,
                                                    width: 160, height: 100))),
                             arrowEdge: .top,
                             content: {
                            //AddTaskSUI(viewModel: viewModel, stringValue: "",isPresented: $showPopover)
                
                    })
            .padding(EdgeInsets(top: -100, leading: 0.0, bottom: 0.0, trailing: 20.0))
        }
        
    }
    func changeStatus(_ status:ToDoTaskStatus,_ task:ToDoTask){
      //  viewModel.changeStatusFor(task, status)
        //viewModel.fetchData()
    }
    func navigateToDetail(_ targetTask: ToDoTask){
        var model = ToDoListViewModelObservable()
        model.list = targetTask
        if let container = viewModel.coreDataManager?.persistentContainer{
            model.coreDataManager = CoreDataManager(persistentContainer:container)
            model.fetchData()
            var taskView = TaskView(navigationModel: navigationModel, viewModel: model, task: targetTask, tasks: targetTask.subTasks ?? [])
            navigationModel.push{
                taskView
            }

        }
    }
}

