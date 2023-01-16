//
//  EditProfileView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/30/1401 AP.
//

import Foundation
import UIKit
extension EditProfileView {
    @MainActor class ViewModel: ObservableObject {
        @Published var profileButtonTapped = false
        @Published var showSavePrompt = false
        @Published var currentImageName: String = "profile"
        @Published var newImage = UIImage(named: "profile")!
        
        
        @Published var fullName: String = ""
        @Published var username: String = ""
        @Published var email: String = ""
    
        @Published var user: User!
        
        
        init() {
            Authentication.shared.getCurrentUser { user, error in
                guard let user = user, error == nil else {
                    return
                }
                self.user = user
                self.fullName = user.fullName
                self.username = user.username
                self.email = user.email
          
                self.currentImageName = user.picture


            }
        }
        func tapProfileButton() {
             profileButtonTapped = !profileButtonTapped
        }
        
        func saveChanges() {
            var fullName: String?
            var email: String?
      
            var username: String?
            var image: UIImage?
            
            if fullName != user.fullName {
                print("should change fullname")
                fullName = self.fullName
            }
            if email != user.email {
                print("should change email")
                email = self.email
            }
            if username != user.username {
                print("should change username")
                username = self.username
            }
            if newImage != UIImage(named: "profile")! {
                print("should change image")
                image = newImage
            }
            user.editInfo(fullName: fullName, picture: image, email: email, username: username)
            
            
        }
    }
}
