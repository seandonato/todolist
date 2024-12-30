//
//  StatusButtonUI.swift
//  ToDoList
//
//  Created by Sean Donato on 12/29/24.
//

import Foundation
import SwiftUI
struct StatusButtonUI: View{
    
    var taskStatus: ToDoTaskStatus
    var action: ()->()
    var title: String
    var body: some View{
        button
    }
    
    @ViewBuilder var button: some View{
        switch self.taskStatus {
        case .ready:
            Button(action: {
                action()
            }, label: {
                Text(verbatim: title)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .foregroundStyle(.white)

            })
            .background(Color(StyleTokens.readySelected ?? .green))
            
            .cornerRadius(StyleTokens.buttonCornerRadius)
            .buttonStyle(.borderless)
        case .inProgress:
            Button(action: {
                action()
            }, label: {
                Text(verbatim: title)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .foregroundStyle(.white)

            })
                .background(Color(StyleTokens.inProgressSelected ?? .purple))
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .buttonStyle(.borderless)


        case .done:
            Button(action: {
                action()
            }, label: {
                Text(verbatim: title)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .foregroundStyle(.white)

            })
                .background(Color(StyleTokens.doneSelected ?? .blue))
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .buttonStyle(.borderless)


        case .blocked:
            Button(action: {
                action()
            }, label: {
                Text(verbatim: title)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .foregroundStyle(.white)

            })
                .background(Color(StyleTokens.blockedSelected ?? .red))
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .buttonStyle(.borderless)


        default:
            Button(action: {
                action()
            }, label: {
                Text(verbatim: title)
            })
                .background(Color(StyleTokens.blockedSelected ?? .red))
                .cornerRadius(StyleTokens.buttonCornerRadius)
                .buttonStyle(.borderless)

        }
    }
}
