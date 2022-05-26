//
//  registerView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
import UIKit
extension RegisterView {
    @MainActor class ModelView: ObservableObject {
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
        
        // MARK: methods
        
        func setPresentingModal(_ val: Bool){
            presentingModal = val
        }
        func tapProfileButton() {
            profileButtonTapped = !profileButtonTapped
        }

        func saveuserData() {
            // get user id
            guard let uid = Authentication.shared.getCurrentUserUid() else { return }
            
            // save user with this id
            let user = User(
                fullName: self.fullname,
                picture: nil,
                email: self.email,
                password: self.password,
                username: self.username,
                uid: uid)
            user.save(with: self.image) { success, error in
                self.isLoading = false
                if success {
                    self.showsMainView = success
                }
                else {
                    self.showAlert = true
                }
            }
            
            
        }
        
        func registerUser() {
            // register
            Authentication.shared.register(email: self.email, password: self.password) { success in
                if success {
                    // if successful, save the user info to database
                    self.saveuserData()
                }
                
            }
        }
    }
}
