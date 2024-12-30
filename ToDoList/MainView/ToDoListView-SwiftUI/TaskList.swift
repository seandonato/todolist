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

    @State var tasks: [ToDoTask]
    var body: some View{
        List{
            ForEach(viewModel.tasks ?? []) { task in
                TaskTableViewCellBasic(action: {status in
                    changeStatus(status,task)
                }, task: task)

            }
        }
    }
    func changeStatus(_ status:ToDoTaskStatus,_ task:ToDoTask){
        viewModel.changeStatusFor(task, status)
        viewModel.fetchData()
    }
}
