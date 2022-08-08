//
//  HomeView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
extension HomeView {
    @MainActor class ViewModel: ObservableObject {
        @Published var showsProfileView = false
        @Published var activities: [Activity]?
        @Published var isLoading = false
        @Published var showsActivityView = false
        @Published var currentUser: User?
       
        init() {
            isLoading = true
            Authentication.shared.getCurrentUser { user, error in
                self.currentUser = user
                guard let user = user, error == nil else { return }
                user.showFeed { activities, error in
                    guard let activities = activities, error == nil else {
                        return
                    }
                    self.activities = activities
                    for i in activities {
                        print(i.name)
                    }
                }
            }
        }
        
    }
}

