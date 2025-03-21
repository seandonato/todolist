//
//  TaskList.swift
//  ToDoList
//
//  Created by Sean Donato on 12/28/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)

struct TaskView:View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                .aspectRatio(contentMode: .fit)
                Text( parentView)
                    .font(.custom(NTTextSyle.light.rawValue, size: 16))
            }
        }
    }
    

    let navigationModel: NavigationModel

    var parentView: String
    @State var viewModel: ToDoListViewModelObservable
    @State var task: ToDoTask
    @State var tasks: [ToDoTask]
    @State var showPopover: Bool = false
    
    var body: some View{
        VStack(alignment: .leading,content:{
            NTListHeader(headerTitle: "task", entityName: task.name, subEntityName: "subtasks:")
            List{
                ForEach(viewModel.tasks ?? []) { task in
                    TaskTableViewCellBasic(action: { status in
                        changeStatus(status, task)
                    }, navigateToDetailAction: { targetTask in
                        navigateToDetail(targetTask)
                    }, task: task)
                }
                .onDelete(perform: { indexSet in
                    delete(at: indexSet)
                })
                NTAddEntityCell(title: "+ Add Sub Task", showPopover: $showPopover) {
                    AddTaskSUI(viewModel: viewModel, stringValue: "",isPresented: $showPopover)
                }
            }
            .listStyle(.plain)
            .padding(EdgeInsets(top: 0.0, leading: 48, bottom: 0.0, trailing: 0.0))
        })
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                btnBack
            }
        })
        .navigationBarTitle("planspark").font(.custom(NTTextSyle.light.rawValue, size: 16))

    }
    func delete(at offsets: IndexSet) {
        for index in offsets{
            if let task = viewModel.tasks?[index]{
                viewModel.deleteTask(task)
            }
        }
    }
    func changeStatus(_ status:ToDoTaskStatus,_ task:ToDoTask){
        viewModel.changeStatusFor(task, status)
    }
    func navigateToDetail(_ targetTask: ToDoTask){
        
    }
}
