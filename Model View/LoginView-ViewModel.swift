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
        @Published var showMainView = false
        @Published var model = false
        @Published var failed = false
        @Published var showSearchView = false
        
       
        func login() {
            Authentication.shared.login(email: self.email, password: self.password) { uid,error  in
                guard let uid = uid, error == nil else {
                    return
                }

                self.isLoading = false
                self.model = true
                self.failed = false
                
                
                if uid == AdminsIdentifiers.admin1 {
                    print("Admin login detected")
                    self.showSearchView = true
                } else {
                    self.showMainView = true
                }
                
            }
        }
        
    }
}
