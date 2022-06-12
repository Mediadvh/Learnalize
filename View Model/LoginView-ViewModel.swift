//
//  LoginView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
extension LoginView {
    @MainActor class ViewModel: ObservableObject {
        @Published var email = ""
        @Published var password = ""
        @Published var isLoading = false
        @Published var showsMainView = false
        @Published var model = false
        
       
        func login() {
            Authentication.shared.login(email: self.email, password: self.password) { success in
                self.isLoading = false
                self.showsMainView = true
                self.model = true
            }
        }
        
    }
}
