//
//  AddTaskToGroupSUI.swift
//  ToDoList
//
//  Created by Sean Donato on 2/1/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct AddTaskToGroupSUI: View{
    @State var viewModel: GroupTasksViewModelObservable
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
                viewModel.saveList(stringValue)
                isPresented = false
            }
            TDSUIButton(text:"dismiss"){
                isPresented = false
            }
            Spacer()
        }).padding()
            
    }
}
