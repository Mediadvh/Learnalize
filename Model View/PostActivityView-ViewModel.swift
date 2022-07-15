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
        @Published var success = false
        @Published var showFailAlert = false
        @Published var isLoading = false
        @Published var pickedColor = "activityCard 1"
        func post() {
            isLoading = true
            if let userId = Authentication.shared.getCurrentUserUid() {
                let uuid = UUID().uuidString
                let activity = Activity(uid: userId + uuid, name: name, description: description, participantsLimit: participantsLimit, tagColor: pickedColor)
                FireStoreManager.shared.save(activity: activity) { success, error in
                    if success {
                        self.success = true
                        self.name = ""
                        self.description = ""
                        self.participantsLimit = 1
                        self.isLoading = false
                    } else {
                        self.success = true
                        self.isLoading = false
                    }
                    
                }
            }
           
        }
    }
}
