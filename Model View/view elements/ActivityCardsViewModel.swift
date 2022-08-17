//
//  ActivityCardsViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/24/1401 AP.
//

import Foundation
extension activityCard {
    @MainActor class ViewModel: ObservableObject {
        @Published var token: String?
        @Published var participant: Participant?
        @Published var join: Bool = false
        @Published var showAlert: Bool = false
        
        func joinActivity(activity: Activity) {
            
            guard activity.participantsLimit > activity.participantsNumber, activity.active == true  else {
                self.showAlert = true
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
        
        
    }
}

