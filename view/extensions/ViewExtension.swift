//
//  ViewExtension.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/27/1401 AP.
//

import SwiftUI
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
