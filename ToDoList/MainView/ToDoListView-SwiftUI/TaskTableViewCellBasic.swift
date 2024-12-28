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
    
    var body: some View {
        HStack{
            statusBlock
            Text(verbatim: task.name)
               // .background(Color.gray)
        }
    }
    
    @ViewBuilder var statusBlock: some View{
        switch self.task.taskStatus {
        case .ready:
            Rectangle()
                .fill(Color(StyleTokens.readySelected ?? .green))
                .frame(width: 24,height: 24)
        case .inProgress:
            Rectangle()
                .fill(Color(StyleTokens.inProgressSelected ?? .purple))
                .frame(width: 24,height: 24)

        case .done:
            Rectangle()
                .fill(Color(StyleTokens.doneSelected ?? .blue))
                .frame(width: 24,height: 24)

        case .blocked:
            Rectangle()
                .fill(Color(StyleTokens.blockedSelected ?? .red))
                .frame(width: 24,height: 24)


        default:
            Rectangle()
                .fill(Color(StyleTokens.readySelected ?? .green))
                .frame(width: 24,height: 24)


        }
    }
    
}
