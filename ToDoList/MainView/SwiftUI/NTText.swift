//
//  NTText.swift
//  ToDoList
//
//  Created by Sean Donato on 3/17/25.
//

import Foundation
import SwiftUI

public enum NTTextSyle: String{
    case regular = "Lato-Regular"
    case light = "Lato-Light"
    
}
struct NTText: View {
    
    var style: NTTextSyle
    var text: String
    var textSize: CGFloat
    
    init(text: String,textSize:CGFloat = 18,style:NTTextSyle = .regular) {
        self.text = text
        self.textSize = textSize
        self.style = style
    }
    var body: some View {
        Text(verbatim: text)
            .font(.custom(style.rawValue, size: textSize))
    }
}
