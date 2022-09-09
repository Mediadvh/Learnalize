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
        @Published var showEditView: Bool = false
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
        @Published private(set) var isRequested = false
        @Published private(set) var followerCount = 0
        @Published private(set) var followingCount = 0
        @Published private(set) var activityCount = 0
        @Published private(set) var followings = [User]()
        @Published private(set) var followers = [User]()
        @Published private(set) var hasRequestedToFollowCur = false
       
        @Published var showsFollowers = false
        @Published var showsFollowings = false
        @Published var loggedOut = false
        @Published var failLogOut = false
        @Published private var currentUser: User?
        
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
        func fetchCurrentUser(completion: @escaping (User?,Error?) -> Void) {
            Authentication.shared.getCurrentUser { curUser, error in
                guard let curUser = curUser, error == nil else {
                    completion(nil, error)
                    return
                }
                completion(curUser, nil)
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
            self.fetchCurrentUser { curUser, error in
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
            self.fetchCurrentUser { curUser, error in
                guard let curUser = curUser, error == nil else {
                    return
                }
                if self.followButtonState == .follow {
                    self.followButtonState = .loading
                    curUser.follow(userToFollow: user.id) { result, error in
                        guard let result = result, error == nil  else { return }
                       
                        if result {
                            self.isFollowed = true
                            self.followBackgroundColor = Colors.green
                            self.followButtonState = .following
                        
                        }
                        
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
//        func checkIsRequested() {
//            guard let user = user else { return }
//            // check if user using the app has requested to follow this user
//
//            user.isRequestedToFollow { res in
//                if res {
//                    self.isRequested = true
//                    self.followButtonState = .requested
//                    self.followBackgroundColor = .gray
//                }
//            }
//        }
        internal func getFollowers() {
            user?.fetchFollowers { users, count, error in
                guard let users = users, let count = count, error == nil else {
                    return
                }
                self.followers = users
                self.followerCount = count
                self.showsFollowers = true
            }
        }
        internal func getFollowings() {
            user?.fetchFollowings { users, count, error in
                guard let users = users, let count = count, error == nil else {
                    return
                }
                self.followings = users
                self.followingCount = count
                self.showsFollowings = true
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
        
//        func checkHasRequestedToFollowCurrentUser() {
//            guard let user = user else { return }
//            self.fetchCurrentUser { curUser, error in
//                guard let curUser = curUser, error == nil else {
//                    return
//                }
//
//
//                curUser.isRequestedToFollow(by: user.id) { res in
//                    if res {
//                        self.hasRequestedToFollowCur = true
//                    } else {
//                        self.hasRequestedToFollowCur = false
//                    }
//                }
//            }
//
//        }
//        func acceptFollowRequest() {
//            guard let user = user else { return }
//            self.fetchCurrentUser { curUser, error in
//                guard let curUser = curUser, error == nil else {
//                    return
//                }
//
//                // add it to current user following
//                curUser.addToFollowers(userToAdd: user.id) { error in
//                    guard error == nil else {
//                        return
//                    }
//                    // remove it from current user requests
//                    curUser.removeFromRequests(userToRemove: user.id) { error in
//                        guard error == nil else {
//                            return
//                        }
//                        self.hasRequestedToFollowCur = false
//
//                    }
//
//                }
//            }
//
//
//        }
        
//        func declineFollowRequest() {
//            guard let user = user else { return }
//
//            self.fetchCurrentUser { curUser, error in
//                guard let curUser = curUser, error == nil else {
//                    return
//                }
//                // remove it from current user requests
//                curUser.removeFromRequests(userToRemove: user.id) { error in
//                    guard error == nil else {
//                        return
//                    }
//                    self.hasRequestedToFollowCur = false
//                }
//            }
//
//        }
        
        func editButtonTapped() {
            self.showEditView = true
        }
    }
}

