//
//  ProjectListView.swift
//  ToDoList
//
//  Created by Sean Donato on 3/17/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct ProjectListView: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                .aspectRatio(contentMode: .fit)
               // Text( parentView)
            }
        }
    }
    @State var viewModel: ListGroupViewModel
    let navigationModel: NavigationModel
    @State var showPopover: Bool = false

    var body: some View{
        VStack(alignment: .leading){
            NTText(text: "projects",style: .light)
                .padding(EdgeInsets(top: 0.0, leading: 8, bottom: 8, trailing: 0.0))
            List{
                ForEach(viewModel.groups ?? []) { project in
                    ProjectListCellView(project: project) { project in
                        navigateToProject(project)
                    }
                }
                .onDelete(perform: { indexSet in
                    // delete(at: indexSet)
                })
                NTAddEntityCell(title: "+ Add Project", showPopover: $showPopover) {
                    AddProjectSUI(viewModel: viewModel, stringValue: "",isPresented: $showPopover)
                }
            }
            .listStyle(.plain)
            //.padding(EdgeInsets(top: 0.0, leading: 8, bottom: 0.0, trailing: 0.0))
            
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarTitle("planspark").font(.custom(NTTextSyle.light.rawValue, size: 16))
    }
    func navigateToProject(_ targetProject: ToDoListProject){
        var model = GroupTasksViewModelObservable()
        model.group = targetProject
        if let container = viewModel.coreDataManager?.persistentContainer{
            model.genCoreDataManager = CoreDataManager(persistentContainer:container)
            model.coreDataManager = ListCoreDataManager(persistentContainer: container)
            model.fetchLists()
            let navigationModel = navigationModel

            var taskView = GroupTasksView(navigationModel: navigationModel, viewModel: model, project: targetProject, tasks: targetProject.tasks ?? [])
            
            navigationModel.push{
                taskView
            }
        }
    }
    func delete(at offsets: IndexSet) {
        for index in offsets{
            if let project = viewModel.groups?[index]{
                viewModel.deleteProject(project)
            }
        }
    }
}
