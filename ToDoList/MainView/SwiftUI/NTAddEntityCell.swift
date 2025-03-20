//
//  NTAddEntityCell.swift
//  ToDoList
//
//  Created by Sean Donato on 3/17/25.
//

import Foundation
import SwiftUI

struct NTAddEntityCell<Content:View>: View{
    
    @ViewBuilder var content: Content
    
    var title: String
    @Binding var showPopover: Bool

    init(title:String,showPopover:Binding<Bool>,@ViewBuilder content:@escaping() -> Content ) {
        self.title = title
        self.content = content()
        self._showPopover = showPopover
    }
    
    var body: some View{
        HStack{
            Spacer()

            Button(title) {
                showPopover = true
            }
            .popover(isPresented: self.$showPopover,
                     attachmentAnchor: .rect(.rect(CGRect(x: 0, y: 20,
                                                          width: 160, height: 100))),
                     arrowEdge: .top,
                     content: {
                content
                
            })
            .padding(EdgeInsets(top: 16, leading: 0.0, bottom: 0.0, trailing: 24))
            }
        }
    
}
