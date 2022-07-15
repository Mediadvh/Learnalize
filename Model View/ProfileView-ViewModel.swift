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
        
        @Published var userIDToShow: String? = Authentication.shared.getCurrentUserUid()
        @Published var user: User!
        @Published var webPicture: WebImage?
        @Published var defaultPicture = UIImage(named: "profile")!
        @Published var username: String = "Loading..."
        @Published var picFromWeb = false
        @Published var activities: [Activity]?
        @Published var success = false
        @Published var canFollow = false
        @Published private(set) var followButtonState: followButtonState = .follow
        @Published private(set) var followColor = Colors.blue
        @Published private(set) var isFollowed = false
        @Published private(set) var followerCount = 0
        @Published private(set) var followingCount = 0
        @Published private(set) var followings = [User]()
        @Published private(set) var followers = [User]()
        @Published var showsFollowers = false
        @Published var showsFollowings = false
        
        func setup() {
            fetchUser { user, error in
                guard let user = user ,error == nil else { return }
                self.user = user
                self.setupUser()
                self.getFollowerCount()
                self.getFollowerCount()
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
            if let pic = user.picture, let username = user.username {
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
                        self.followColor = Colors.green
                        self.followButtonState = .following
                    }
                } else if self.followButtonState == .following {
                    self.followButtonState = .loading
                    curUser.unfollow(userToUnfollow: user.id) { error in
                        guard error == nil  else { return }
                        self.isFollowed = true
                        self.followColor = Colors.blue
                        self.followButtonState = .follow
                    }
                }
            }
        }
        func getFollowerCount() {
            user.getFollowersCount { count in
                if let count = count {
                    print(count)
                    self.followerCount = count
                }
            }
        }
        
        func getFollowingCount() {
            user.getFollowingsCount { count in
                if let count = count {
                    print(count)
                    self.followingCount = count
                }
            }
        }
        func showActivities() {
            FireStoreManager.shared.fetchActivities(filter: user.id) { activities, error in
                guard let activities = activities, error == nil else {
                    return
                }
                self.activities = activities
            }
        }
        
        func checkIsFollowed() {
            guard let user = user else { return }
            // check if its followed by the user using the app
            user.isFollowed { res in
                if res {
                    self.isFollowed = true
                    self.followButtonState = .following
                    self.followColor = .green
                }
            }
        }
        func getFollowers() {
            user.fetchFollowers { users, error in
                guard let users = users, error == nil else {
                    return
                }
                self.followers = users
            }
        }
        func getFollowings() {
            user.fetchFollowings { users, error in
                guard let users = users, error == nil else {
                    return
                }
                self.followings = users
            }
        }

        
    }
}

