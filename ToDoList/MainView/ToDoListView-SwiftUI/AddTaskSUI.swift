//
//  AddTaskSUI.swift
//  ToDoList
//
//  Created by Sean Donato on 1/16/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct AddTaskSUI: View{
    @State var viewModel: ToDoListViewModelObservable
    @State var stringValue: String
    @Binding var isPresented: Bool
    var body: some View{
        VStack( spacing: 24, content: {
            Text(verbatim: "Task name")
                .padding(EdgeInsets(top: 32, leading: 12, bottom: 12, trailing: 12))
            TextField("", text: $stringValue)
                .frame(height: 24)
                .padding()
                .border(.gray, width: 1)
            TDSUIButton(text:"add") {
                viewModel.saveTask(stringValue)
                isPresented = false
            }
            TDSUIButton(text:"dismiss"){
                isPresented = false

            }
            Spacer()
        }).padding()
            
    }
}
