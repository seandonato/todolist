//
//  NTListHeader.swift
//  ToDoList
//
//  Created by Sean Donato on 3/17/25.
//

import Foundation
import SwiftUI

struct NTListHeader:View{
        
    var headerTitle: String?
    var entityName: String
    var subEntityName: String
    
    init(headerTitle: String? = nil,entityName: String,subEntityName: String) {
        self.headerTitle = headerTitle
        self.entityName = entityName
        self.subEntityName = subEntityName
    }
    var body: some View {
        if headerTitle == nil{
            headerNoTitle
        }else{
            headerWithTitle
        }
    }
    
    @ViewBuilder var headerWithTitle: some View{
        VStack(alignment: .leading, spacing: 8, content: {
            NTText(text: headerTitle ?? "",style: .light)
            NTText(text: entityName)
                .padding(EdgeInsets(top: 0.0, leading: 16, bottom: 0.0, trailing: 16))
            NTText(text: subEntityName,style: .light)
                .padding(EdgeInsets(top: 0.0, leading: 32, bottom: 0.0, trailing: 0.0))
        })
        .padding(EdgeInsets(top: 0.0, leading: 16, bottom: 0.0, trailing: 16))

    }
    @ViewBuilder var headerNoTitle: some View{
        VStack(alignment: .leading, spacing: 8, content: {
            NTText(text: entityName)
                .padding(EdgeInsets(top: 0.0, leading: 0, bottom: 0.0, trailing: 16))
            NTText(text: subEntityName,style: .light)
                .padding(EdgeInsets(top: 0.0, leading: 16, bottom: 0.0, trailing: 0.0))
        })
        .padding(EdgeInsets(top: 0.0, leading: 16, bottom: 0.0, trailing: 16))

    }

}
