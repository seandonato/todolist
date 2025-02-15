//
//  StyleTokens.swift
//  ToDoList
//
//  Created by Sean Donato on 8/16/24.
//

import Foundation
import UIKit
import SwiftUI

struct StyleTokens{
    
    //button
    static var buttonCornerRadius = CGFloat(8.0)
    static var buttonFont = UIFont(name: "Arial", size: 22)
    
    //status buttons
    static var readySelected = UIColor(hex: "#00d10cff")
    static var readyUnSelected = UIColor(hex: "#e2f8e4ff")

    static var blockedSelected = UIColor(hex: "#ff2929ff")
    static var blockedUnSelected = UIColor(hex: "#fbcdcdff")

    static var inProgressSelected = UIColor(hex: "#c14dffff")
    static var inProgressUnSelected = UIColor(hex: "#d7c1e2ff")
    
    static var doneSelected =  UIColor(hex: "#007dd1ff")
    static var doneUnSelected = UIColor(hex: "#e1eff8ff")
    
    static var primaryButton = Color(uiColor: UIColor(hex: "#007dd1ff") ?? .clear)
    static var primaryButtonClicked = Color(uiColor: UIColor(hex: "#e1eff8ff") ?? .clear)


}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
