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
                TaskTableViewCellBasic(task: task)

            }
        }
    }
}
