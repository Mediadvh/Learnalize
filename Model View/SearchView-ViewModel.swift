//
//  SearchView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
import UIKit
enum SearchMode {
    case searchActivity
    case searchUser
}
extension SearchView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mode: SearchMode = .searchUser
        @Published var text = ""
        @Published var resultActivities = [Activity]()
        @Published var resultUsers = [User]()
        @Published var foundResult = true
        @Published var isLoading = false
        
      
        func searchActivity(name: String) {
            FireStoreManager.shared.searchActivity(by: name) { activities, error in
                self.isLoading = true
                guard error == nil, let activities = activities else {
                    self.foundResult = false
                    self.isLoading = false
                    return
                }
                if activities.isEmpty {
                    self.foundResult = false
                    self.isLoading = false
                }
                self.foundResult = true
                self.resultActivities = activities
    
            }
        }
        
        func searchUser(username: String) {
            self.isLoading = true
            FireStoreManager.shared.searchUser(by: text) { users, error in
                guard error == nil, let users = users else {
                    self.foundResult = false
                    self.isLoading = false
                    return
                }
                if users.isEmpty {
                    self.foundResult = false
                    self.isLoading = false
                } else {
                    self.foundResult = true
                    self.isLoading = false
                    self.resultUsers = users
                    
                
                }
                
            }
        }
        
        
        
        
        
    }
}
