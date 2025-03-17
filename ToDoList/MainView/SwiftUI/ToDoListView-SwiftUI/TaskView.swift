//
//  TaskList.swift
//  ToDoList
//
//  Created by Sean Donato on 12/28/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
//struct TaskList:View{
struct TaskView:View{

    let navigationModel: NavigationModel

    @State var viewModel: ToDoListViewModelObservable
    @State var task: ToDoTask
    @State var tasks: [ToDoTask]
    @State var showPopover: Bool = false
    
    var body: some View{
        VStack(alignment: .leading,content:{
            VStack(alignment: .leading, content: {
                Text(verbatim: "Task name:")
                    .padding()
                Text(verbatim: task.name)
                    .padding()
                Text(verbatim: "subtasks:")
                    .padding()

            })

            List{
                ForEach(viewModel.tasks ?? []) { task in
                    TaskTableViewCellBasic(action: { status in
                        changeStatus(status, task)
                    }, navigateToDetailAction: { targetTask in
                        navigateToDetail(targetTask)
                    }, task: task)
                    
                }
                .onDelete(perform: { indexSet in
                    delete(at: indexSet)
                })
                NTAddEntityCell(title: "+ Add Sub Task", showPopover: $showPopover) {
                    AddTaskSUI(viewModel: viewModel, stringValue: "",isPresented: $showPopover)
                }
            }
                
                .listStyle(.plain)
            
            })
        
    }
    func delete(at offsets: IndexSet) {
        for index in offsets{
            if let task = viewModel.tasks?[index]{
                viewModel.deleteTask(task)
            }
        }
    }
    func changeStatus(_ status:ToDoTaskStatus,_ task:ToDoTask){
        viewModel.changeStatusFor(task, status)
        //viewModel.fetchData()
    }
    func navigateToDetail(_ targetTask: ToDoTask){
        
    }
}
