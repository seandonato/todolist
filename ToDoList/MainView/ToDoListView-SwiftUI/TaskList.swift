//
//  TaskList.swift
//  ToDoList
//
//  Created by Sean Donato on 12/28/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct TaskList:View{
    
    @State var viewModel: ToDoListViewModelObservable
    @State var task: ToDoTask
    @State var tasks: [ToDoTask]
    var body: some View{
        Text(verbatim: task.name)
        List{
            ForEach(viewModel.tasks ?? []) { task in
                TaskTableViewCellBasic(action: { status in
                    changeStatus(status, task)
                }, navigateToDetailAction: { targetTask in
                    navigateToDetail(targetTask)
                }, task: task)

            }
        }
    }
    func changeStatus(_ status:ToDoTaskStatus,_ task:ToDoTask){
        viewModel.changeStatusFor(task, status)
        viewModel.fetchData()
    }
    func navigateToDetail(_ targetTask: ToDoTask){
        
    }
}
