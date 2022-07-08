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
     
        
        init() {
            isLoading = true
            FireStoreManager.shared.fetchActivities(filter: Authentication.shared.getCurrentUserUid()!) { activities , error in
                if let activities = activities {
                    self.activities = activities
                    self.isLoading = false
                }
                
                
            }
        }
    }
}
