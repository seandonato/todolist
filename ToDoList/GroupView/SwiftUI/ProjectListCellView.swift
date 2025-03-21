//
//  ProjectListCellView.swift
//  ToDoList
//
//  Created by Sean Donato on 3/21/25.
//

import Foundation
import SwiftUI


struct ProjectListCellView: View{
    
    var project: ToDoListProject
    var navigateToProjectAction: (_ project:ToDoListProject) -> ()

    var body: some View{
        VStack(alignment: .leading){
            NTText(text: project.name)
            HStack(spacing: 8){
                TaskCountBubble(count: project.readyTasks ?? 0, status: .ready)
                TaskCountBubble(count: project.inProgressTasks ?? 0, status: .inProgress)
                TaskCountBubble(count: project.blockedTasks ?? 0, status: .blocked)
                TaskCountBubble(count: project.doneTasks ?? 0, status: .done)
            }
            .padding(EdgeInsets(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 0.0))
        }
        .onTapGesture {
            navigateToProjectAction(project)
        }
    }
}
