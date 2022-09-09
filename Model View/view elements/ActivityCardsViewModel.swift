//
//  ActivityCardsViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/24/1401 AP.
//

import Foundation
import UIKit
extension activityCard {
    @MainActor class ViewModel: ObservableObject {
        @Published var token: String?
        @Published var participant: Participant?
        @Published var join: Bool = false
        @Published var showLimitAlert: Bool = false
        @Published var showDeactivateAlert: Bool = false
        @Published var deletedActivity: Bool = false
        @Published var username: String = "Loading..."
        @Published var showProfileView = false
        @Published var image: String = "profile"
        @Published var activity: Activity!
        init(activity: Activity) {

            retrieveHost(activity: activity)
            self.activity = activity
           
        }
        
        func joinActivity(activity: Activity) {
            
            guard activity.participantsLimit > activity.participantsNumber  else {
                self.showLimitAlert = true
                return
            }
            guard activity.active == true else {
                self.showDeactivateAlert = true
                return
            }
            guard let currId = Authentication.shared.getCurrentUserUid() else { return }
            
            RoomAPIHandler.roomForGuest(roomId: activity.uid, userId: currId) { tokenResponse, error in
                guard let tokenResponse = tokenResponse, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.participant = Participant(role: .guest, askedForPermission: false, uid: currId)
                    self.token = tokenResponse.token
                    self.join = true
                }
               
            }
         
        }
        
        
        func retrieveHost(activity: Activity) {
            activity.fetchHost { user, error in
                guard let user = user, error == nil else {
                    return
                }
                
                self.username = user.username
                self.image = user.picture
            }
        }
        
        func usernameButtonTapped() {
            self.showProfileView = true
        }
        func deleteActivity() {
            FireStoreManager.shared.deleteActivity(with: activity.uid) {error in
                guard error == nil else {
                    return
                }
                self.deletedActivity = true
            }
        }
        
    }
}

