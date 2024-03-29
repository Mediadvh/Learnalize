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
        @Published var showEmptyAlert: Bool = false

        
        fileprivate func create(_ activity: Activity) {
            activity.create() { success, error in
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
            if name == "" || description == "" {
                self.showEmptyAlert = true
                return
            }
            
            isLoading = true
//            name = name.trimmingCharacters(in: .whitespaces)
            name = String(name.filter { !" \n\t\r".contains($0) })
          
            if let userId = Authentication.shared.getCurrentUserUid() {
              // create room
                FireStoreManager.shared.fetchUser(with: userId) { user, error in
                    guard error == nil, let user = user else {
                        DispatchQueue.main.async {
                            self.showFailAlert = true
                            self.isLoading = false
                        }
                        return
                    }
                    RoomAPIHandler.roomForHost(name: self.name, description: self.description, userId:  userId) { room, token, error in
                        guard let room = room, let token = token, error == nil else {
                            DispatchQueue.main.async {
                                self.showFailAlert = true
                                self.isLoading = false
                            }
                           
                            return
                        }
                        DispatchQueue.main.async {
                            self.token = token.token
                            self.activity = Activity(name: self.name, description: self.description, participantsLimit: self.participantsLimit, tagColor: self.pickedColor, createdAt: room.created_at, uid: room.id, active: room.active, hostId: userId, host: user)
                            self.create(self.activity!)
                        }
                        
                       
                    }
                }
               

            }
        }
        
        
    }
   
}
    
