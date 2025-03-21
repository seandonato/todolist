//
//  TaskCountBubble.swift
//  ToDoList
//
//  Created by Sean Donato on 3/21/25.
//

import Foundation
import SwiftUI
struct TaskCountBubble: View {
    
    var count: Int

    var status: ToDoTaskStatus
    
    init(count: Int,status:ToDoTaskStatus) {
        self.count = count
        self.status = status
    }
    var body: some View {
        if count == 0{
            EmptyView()
        }else{
            ZStack{
                statusBubble
                NTText(text: count.description)
                    .foregroundStyle(Color.white)
            }
        }
    }
    
    @ViewBuilder var statusBubble: some View{
        switch status {
        case .ready:
            Circle()
                .fill( Color(StyleTokens.readySelected ?? .green))
                .frame(width: 30,height: 30)

        case .inProgress:
            Circle()
                .fill( Color(StyleTokens.inProgressSelected ?? .green))
                .frame(width: 30,height: 30)

        case .done:
            Circle()
                .fill( Color(StyleTokens.doneSelected ?? .green))
                .frame(width: 30,height: 30)

        case .blocked:
            Circle()
                .fill( Color(StyleTokens.blockedSelected ?? .green))
                .frame(width: 30,height: 30)

        }
        
    }
}
