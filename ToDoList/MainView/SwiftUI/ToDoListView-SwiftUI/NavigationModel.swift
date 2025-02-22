//
//  NavigationModel.swift
//  ToDoList
//
//  Created by Sean Donato on 2/1/25.
//

import Foundation
import SwiftUI

//bridging between swiftui and uikit
class NavigationModel {
    var navigationController: UINavigationController?
    
    func push<V: View>(@ViewBuilder _ view: () -> V) {
        let vc = UIHostingController(rootView: view())
        navigationController?.pushViewController(vc, animated: true)
    }
}
