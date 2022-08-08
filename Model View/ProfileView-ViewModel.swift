//
//  ProfileView-ViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/21/1401 AP.
//

import Foundation
import UIKit
import SDWebImage
import SDWebImageSwiftUI

enum followButtonState:String { case follow = "Follow", following = "Following", loading = "Loading..." }
extension ProfileView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var showChat: Bool = false
        @Published var userIDToShow: String? = Authentication.shared.getCurrentUserUid()
        @Published var user: User?
        @Published var webPicture: WebImage?
        @Published var defaultPicture = UIImage(named: "profile")!
        @Published var username: String = "Loading..."
        @Published var picFromWeb = false
        @Published var activities: [Activity]?
        @Published var success = false
        @Published var canFollow: Bool?
        @Published private(set) var followButtonState: followButtonState = .follow
        @Published private(set) var followBackgroundColor = Colors.blue
      
        @Published private(set) var isFollowed = false
        @Published private(set) var followerCount = 0
        @Published private(set) var followingCount = 0
        @Published private(set) var activityCount = 0
        @Published private(set) var followings = [User]()
        @Published private(set) var followers = [User]()
        @Published var showsFollowers = false
        @Published var showsFollowings = false
        @Published var loggedOut = false
        @Published var failLogOut = false
        
        func setup() {
            fetchUser { user, error in
                guard let user = user ,error == nil else { return }
                self.user = user
                self.setupUser()
                self.getFollowers()
                self.getFollowings()
                self.checkIsFollowed()
            }
        }
        func fetchUser(completionHandler: @escaping (User?, Error?) -> Void) {
            guard let userId = userIDToShow else {
                print("DEBUG: user id invalid")
                return
            }
            
            FireStoreManager.shared.fetchUser(with: userId ,completionHandler: completionHandler)
        }
        func setupUser() {
            if let pic = user?.picture, let username = user?.username {
                self.username = username
                guard let url = URL(string: pic) else { return }
                self.webPicture = WebImage(url: url)
                self.picFromWeb = true
            } else {
                self.picFromWeb = false
            }
            self.showActivities()
            hasFollowButton()
        }
        
        private func hasFollowButton() {
            guard let user = user else { return }
            Authentication.shared.getCurrentUser { curUser, error in
                guard let curUser = curUser, error == nil else {
                    return
                }
                if user.id != curUser.id {
                    self.canFollow = true
                    return
                } else {
                    self.canFollow = false
                }
            }
        }
        
        func followButtonTapped() {
            guard let user = user else { return }
            Authentication.shared.getCurrentUser { curUser, error in
                guard let curUser = curUser, error == nil else {
                    return
                }
                if self.followButtonState == .follow {
                    self.followButtonState = .loading
                    curUser.follow(userToFollow: user.id) { error in
                        guard error == nil  else { return }
                        self.isFollowed = true
                        self.followBackgroundColor = Colors.green
                        self.followButtonState = .following
                    }
                } else if self.followButtonState == .following {
                    self.followButtonState = .loading
                    curUser.unfollow(userToUnfollow: user.id) { error in
                        guard error == nil  else { return }
                        self.isFollowed = true
                        self.followBackgroundColor = Colors.blue
                        self.followButtonState = .follow
                    }
                }
            }
        }
        func getFollowerCount() {
            user?.getFollowersCount { count in
                if let count = count {
                    print(count)
                    self.followerCount = count
                }
            }
        }
        
        func getFollowingCount() {
            user?.getFollowingsCount { count in
                if let count = count {
                    print(count)
                    self.followingCount = count
                }
            }
        }
        func showActivities() {
            guard let id = user?.id else { return }
            
            FireStoreManager.shared.fetchActivities(filter: id) { activities, count, error in
                guard let activities = activities, let count = count, error == nil else {
                    return
                }
                self.activities = activities
                self.activityCount = count
            }
        }
        
        func checkIsFollowed() {
            guard let user = user else { return }
            // check if its followed by the user using the app
            user.isFollowed { res in
                if res {
                    self.isFollowed = true
                    self.followButtonState = .following
                    self.followBackgroundColor = .green
                }
            }
        }
        private func getFollowers() {
            user?.fetchFollowers { users, count, error in
                guard let users = users, let count = count, error == nil else {
                    return
                }
                self.followers = users
                self.followerCount = count
            }
        }
        private func getFollowings() {
            user?.fetchFollowings { users, count, error in
                guard let users = users, let count = count, error == nil else {
                    return
                }
                self.followings = users
                self.followingCount = count
            }
        }

        func logout() {
            guard let user = user else {
                return
            }
            if user.logout() {
                loggedOut = true
            } else {
                failLogOut = true
            }
            
        }
    }
}

