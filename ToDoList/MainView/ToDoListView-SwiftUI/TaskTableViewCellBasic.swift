//
//  TaskTableViewCellBasic.swift
//  ToDoList
//
//  Created by Sean Donato on 12/17/24.
//

import Foundation
import SwiftUI


struct TaskTableViewCellBasic: View {
    
    let task: ToDoTask
    @State var expanded = false
    var body: some View {
        VStack(alignment: .leading, content: {
            HStack{
                statusBlock
                Text(verbatim: task.name)
            }
            statusButtons
        })
        
    }
    
    @ViewBuilder var statusBlock: some View{
        switch self.task.taskStatus {
        case .ready:
            Rectangle()
                .fill(Color(StyleTokens.readySelected ?? .green))
                .frame(width: 24,height: 24)
                .onTapGesture {
                    withAnimation{                    expanded.toggle()
                    }
                }
        case .inProgress:
            Rectangle()
                .fill(Color(StyleTokens.inProgressSelected ?? .purple))
                .frame(width: 24,height: 24)
                .onTapGesture {
                    withAnimation{                    expanded.toggle()
                    }
                }
        case .done:
            Rectangle()
                .fill(Color(StyleTokens.doneSelected ?? .blue))
                .frame(width: 24,height: 24)
                .onTapGesture {
                    withAnimation{                    expanded.toggle()
                    }
                }
        case .blocked:
            Rectangle()
                .fill(Color(StyleTokens.blockedSelected ?? .red))
                .frame(width: 24,height: 24)
                .onTapGesture {
                    withAnimation{                    expanded.toggle()
                    }
                }

        default:
            Rectangle()
                .fill(Color(StyleTokens.readySelected ?? .green))
                .frame(width: 24,height: 24)
                .onTapGesture {
                    withAnimation{                    expanded.toggle()
                    }
                }

        }
    }
    
    @ViewBuilder var statusButtons: some View{
        if(expanded == true){
            HStack{
                StatusButtonUI(taskStatus: .ready, action: {
                    
                }, title: "ready")
                StatusButtonUI(taskStatus: .inProgress, action: {
                    
                }, title: "in progress")
                StatusButtonUI(taskStatus: .blocked, action: {
                    
                }, title: "blocked")
                StatusButtonUI(taskStatus: .done, action: {
                    
                }, title: "done")

            }
        }else{
            EmptyView()
        }
    }
    
}
