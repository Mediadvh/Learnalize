//
//  PostActivityView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
extension PostActivityView {
    @MainActor class ViewModel: ObservableObject {
        @Published var name = ""
        @Published var description = ""
        @Published var participantsLimit = 1
        @Published var showingAlert = false
        
        func post() {
            
            if let userId = Authentication.shared.getCurrentUserUid() {
                let uuid = UUID().uuidString
                let activity = Activity(uid: userId + uuid, name: name, description: description, participantsLimit: participantsLimit)
                FireStoreManager.shared.save(activity: activity) { success, error in
                    if success {
                        self.showingAlert = true
                        self.name = ""
                        self.description = ""
                        self.participantsLimit = 1
                        print("successfully posted the activity to database")
                        
                    }
                }
            }
           
        }
    }
}
