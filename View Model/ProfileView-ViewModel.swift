//
//  ProfileView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
import UIKit
import SDWebImage
import SDWebImageSwiftUI
extension ProfileView {
    @MainActor class ViewModel: ObservableObject {

        @Published var user: User!
        @Published var webPicture: WebImage?
        @Published var defaultPicture = UIImage(named: "profile")!
        @Published var username: String = ""
        @Published var picFromWeb = false
        @Published var activities: [Activity]?
        
        init()  {
            
            guard let currentUid = Authentication.shared.getCurrentUserUid() else { return }
            print(currentUid)
            FireStoreManager.shared.fetchUser(userId: currentUid) { [self] fetchedUser, error in
                
                if let fetchedUser = fetchedUser, error == nil {
                    let user = User(fullName:  fetchedUser.fullName, picture: fetchedUser.picture, email:  fetchedUser.email, password:  fetchedUser.password, username: fetchedUser.username, id: fetchedUser.id)
                    self.user = user
                    
                 
                    if let picture = fetchedUser.picture {
                        guard let url = URL(string: picture) else { return }
                        webPicture = WebImage(url: url)
                        picFromWeb = true
                    } else {
                        picFromWeb = false
                    }
                    username = fetchedUser.username
                    
                }
                
            }
            
            showActivities()
        }
        
        func showActivities() {
            FireStoreManager.shared.fetchActivities(filter: Authentication.shared.getCurrentUserUid()!) { activities , error in
                if let activities = activities {
                    print(activities[0].name)
                    self.activities = activities
                }
                
                
            }
        }
    }
}
