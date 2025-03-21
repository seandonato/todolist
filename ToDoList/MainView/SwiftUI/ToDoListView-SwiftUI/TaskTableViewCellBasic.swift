//
//  TaskTableViewCellBasic.swift
//  ToDoList
//
//  Created by Sean Donato on 12/17/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct TaskTableViewCellBasic: View {
    var action: (_ status:ToDoTaskStatus) -> ()
    var navigateToDetailAction: (_ task:ToDoTask) -> ()

    let task: ToDoTask
    
    @State var expanded = false
    var body: some View {
        VStack(alignment: .leading, content: {
            HStack{
                statusBlock
                HStack{
                    Text(verbatim: task.name)
                    Spacer()
                    Image(systemName: "chevron.right")
                }.onTapGesture {
                    navigateToDetailAction(task)
                }
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
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .shadow(color:.gray,radius: 1,x: -2,y:2)
                .onTapGesture {
                    withAnimation{   
                        expanded.toggle()
                    }
                }
        case .inProgress:
            Rectangle()
                .fill(Color(StyleTokens.inProgressSelected ?? .purple))
                .frame(width: 24,height: 24)
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .shadow(color:.gray,radius: 1,x: -2,y:2)

                .onTapGesture {
                    withAnimation{          
                        expanded.toggle()
                    }
                }
        case .done:
            Rectangle()
                .fill(Color(StyleTokens.doneSelected ?? .blue))
                .frame(width: 24,height: 24)
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .shadow(color:.gray,radius: 1,x: -2,y:2)

                .onTapGesture {
                    withAnimation{         
                        expanded.toggle()
                    }
                }
        case .blocked:
            Rectangle()
                .fill(Color(StyleTokens.blockedSelected ?? .red))
                .frame(width: 24,height: 24)
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .shadow(color:.gray,radius: 1,x: -2,y:2)

                .onTapGesture {
                    withAnimation{           
                        expanded.toggle()
                    }
                }

        default:
            Rectangle()
                .fill(Color(StyleTokens.readySelected ?? .green))
                .frame(width: 24,height: 24)
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .shadow(color:.gray,radius: 1,x: -2,y:2)

                .onTapGesture {
                    withAnimation{       
                        expanded.toggle()
                    }
                }

        }
    }
    
    @ViewBuilder var statusButtons: some View{
        if(expanded == true){
            HStack{
                StatusButtonUI(taskStatus: .ready, action: {
                    self.action(.ready)

                }, title: "ready")
                StatusButtonUI(taskStatus: .inProgress, action: {
                    self.action(.inProgress)

                }, title: "in progress")
                StatusButtonUI(taskStatus: .blocked, action: {
                    self.action(.blocked)

                }, title: "blocked")
                StatusButtonUI(taskStatus: .done, action: {
                    self.action(.done)

                }, title: "done")

            }
        }else{
            EmptyView()
        }
    }
    
}
