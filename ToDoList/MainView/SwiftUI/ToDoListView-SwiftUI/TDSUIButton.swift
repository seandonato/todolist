//
//  SwiftUIButton.swift
//  ToDoList
//
//  Created by Sean Donato on 2/1/25.
//

import Foundation
import SwiftUI

struct TDSUIButton: View {
    @State private var isPressed = false
    var text: String
    var action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isPressed ? StyleTokens.primaryButtonClicked : StyleTokens.primaryButton)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}
