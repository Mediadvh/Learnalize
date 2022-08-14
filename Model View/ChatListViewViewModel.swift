//
//  messageViewViewModel\.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/10/1401 AP.
//

import Foundation
import SDWebImage
extension ChatListView {
    @MainActor class ViewModel: ObservableObject {
        @Published var currentUser: User?
        @Published var chatUser: User?
        @Published var showNewMessageList = false
        @Published var NewMessageList = [User]()
        @Published var recentChat = [Chat]()
        @Published var showDefaultList = true
        init() {
            if let user = Cache.shared.getCurrentUser() {
                currentUser = user
            } else {
                Authentication.shared.getCurrentUser { user, error in
                    guard let user = user, error == nil else { return }
                    self.currentUser = user
                }
            }
            getRecentMessages()
            
        }
        private func getRecentMessages() {
            guard let userId = Authentication.shared.getCurrentUserUid() else { return }
            FireStoreManager.shared.fetchRecentMessages(userId: userId) { recentChat, error in
                guard let recentChat = recentChat, error == nil else {
                    return
                }

                self.recentChat = recentChat
                self.showDefaultList = false
                print(recentChat)
                
                
            }
        }
       
        
        func getNewMessageList() {
            // user can start chats with followings
            guard let user = currentUser  else { return }
            user.fetchFollowings { users, _ , error  in
                guard let users = users, error == nil else {
                    return
                }
                self.NewMessageList = users
                self.showNewMessageList = true
            }
        }
    }
}

