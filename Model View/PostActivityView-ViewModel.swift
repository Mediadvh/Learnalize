//
//  PostActivityView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
extension PostActivityView {
    @MainActor class ViewModel: ObservableObject {
        //input
        @Published var name = ""
        @Published var description = ""
        @Published var participantsLimit = 1
       
        
        // output
        @Published var success = false
        @Published var showFailAlert = false
        @Published var isLoading = false
        @Published var pickedColor = "activityCard 1"
        @Published var activity: Activity?
        @Published var token: String?
        
        fileprivate func create(_ activity: Activity) {
            activity.save() { success, error in
                if success {
                    self.success = true
                    self.name = ""
                    self.description = ""
                    self.participantsLimit = 1
                    self.isLoading = false
                } else {
                    self.success = false
                    self.isLoading = false
                }
                
            }
        }
        
        func post() {
            isLoading = true
            if let userId = Authentication.shared.getCurrentUserUid() {
              // create room
                RoomAPIHandler.roomForHost(name: name, description: description, userId:  Authentication.shared.getCurrentUserUid()!) { room, token, error in
                    guard let room = room, let token = token, error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.token = token.token
                        self.activity = Activity(name: self.name, description: self.description, participantsLimit: self.participantsLimit, tagColor: self.pickedColor, createdAt: room.created_at, uid: room.id, active: room.active, hostId: userId)
                        self.create(self.activity!)
                    }
                    
                   
                }

            }
        }
        
        
    }
   
}
    
