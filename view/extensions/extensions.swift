//
//  extensions.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/14/1401 AP.
//

import Foundation
import UIKit
import SwiftUI
// MARK: UIScreen
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
// MARK: Dictionary
extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        get {
            return self[index(startIndex,offsetBy: i)]
        }
    }
}
// MARK: View
extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>, with barTitle: String) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle(barTitle)
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle(barTitle)
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

