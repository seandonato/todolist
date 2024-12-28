//
//  TaskList.swift
//  ToDoList
//
//  Created by Sean Donato on 12/28/24.
//

import Foundation
import SwiftUI

struct TaskList:View{
    let viewModel: ToDoListViewModel

    var tasks: [ToDoTask]
    var body: some View{
        List(tasks) { task in
            
            HStack{}
        }
    }
}
