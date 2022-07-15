//
//  registerView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
import UIKit
extension RegisterView {
    @MainActor class ViewModel: ObservableObject {
       
        @Published var profileButtonTapped = false
        @Published var presentingModal = false
        @Published var image: UIImage = UIImage(named: "profile")!
        @Published var fullname = ""
        @Published var username = ""
        @Published var email = ""
        @Published var password = ""
        @Published var willMoveToLoginView = false
        @Published var isLoading = false
        @Published var showAlert = false
        @Published var showsMainView = false
        @Published var failed = false
        @Published private(set) var errorType: ErrorTypes?
        // MARK: methods
        
        func setPresentingModal(_ val: Bool){
            presentingModal = val
        }
        func tapProfileButton() {
            profileButtonTapped = !profileButtonTapped
        }

        
        private func CheckInput() {
            if fullname == "" || username == "" || email == "" || password == "" {
                errorType = .fieldEmpty
            } else if  password.count < 6 {
                errorType = .passwordLength
            }
        }
        func register() {
            CheckInput()
            
            let user = User(
                fullName: self.fullname,
                picture: nil,
                email: self.email,
                password: self.password,
                username: self.username,
                id: nil)
            
            user.create(with: image) { success in
                self.isLoading = false
                if success {
                    self.showsMainView = success
                }
                else {
                    self.showAlert = true
                }
                self.failed = !success
            }
                
            
            
            
            
            
            
        }
        
        
    }
}
