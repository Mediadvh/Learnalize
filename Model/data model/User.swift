//
//  User.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//

import Foundation
import UIKit
import SDWebImage
import FirebaseFirestoreSwift
import FirebaseAnalytics
class User: Codable {
    // MARK: properties
    
    internal var fullName: String!
    internal var picture: String!
    internal var email: String!
    internal var password: String!
    internal var id: String!
    internal var username: String!
    
    
    // MARK: initializer
    init(fullName: String, picture: String? ,email: String, password:String, username: String, id: String?) {
        self.fullName = fullName
        self.email = email
        self.password = password
        self.username = username
        self.id = id
        self.picture = picture
    }
    
    //MARK: methods
    func showInfo() {
        
    }
    
    func editInfo(fullName: String? = nil, picture:String? = nil ,email: String? = nil, password:String? = nil, username: String? = nil) {
        if let fullName = fullName {
            self.fullName = fullName
        }
        if let picture = picture {
            self.picture = picture
        }
        if let email = email {
            self.email = email
        }
        if let password = password {
            self.password = password
        }
        if let username = username {
            self.username = username
        }
        // update data base
    }
    
    
    
}

extension User: Identifiable {
    
}
// user initialization
extension User {
    
    // MARK: internal methods
    // check if it's the current user
    internal func currentId() -> String {
        return Authentication.shared.getCurrentUserUid() ?? ""
    }
    
    // save user
    
    
    internal func create(with image: UIImage, completionHandler: @escaping(Bool) -> Void) {
        // register it first
        register { res in
            guard res == true else {
                print("DEBUG: register unsuccessful")
                completionHandler(false)
                return
            }
            self.id = Authentication.shared.getCurrentUserUid()
            // check if there's a profile image
            
            // save pic
            self.saveProfileImage(image: image) { url, error in
                // save all data
                
                guard error == nil else {
                    print("DEBUG: saving image was unsuccessful")
                    completionHandler(false)
                    return }
                self.picture = url?.absoluteString
                self.save { finalRes, error in
                    guard error == nil else {
                        print("DEBUG: saving user data was unsuccessful")
                        completionHandler(false)
                        return }
                    
                    print("successfully registered into the app!")
                    completionHandler(true)
                }
            }
        }
    }
    private func saveProfileImage(image: UIImage, completionHandler: @escaping (URL?, Error?) -> Void){
        let db = FireStoreManager.shared
        
        guard let uid = db.auth.currentUser?.uid else { return }
        
        let ref = db.storage.reference(withPath: uid)
        
        // save image
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completionHandler(nil,error)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    completionHandler(nil,error)
                    return
                }
                completionHandler(url,nil)
            }
        }
        
        
    }
    //MARK: private methods
    private func register(completionHandler: @escaping (Bool) -> Void) {
        Authentication.shared.register(email: email, password: password, completionHandler: completionHandler)
    }
    private func save(completionHandler: @escaping (Bool, Error?) -> Void){
        let db = FireStoreManager.shared
        let collectionRef = db.userCollection
        if let uid = Authentication.shared.getCurrentUserUid() {
            //try collectionRef.document(uid).setData(from: self)
            let dictionary = Converter.UserToData(user: self)
            collectionRef.document(uid).setData(dictionary) { error in
                guard error == nil else {
                    completionHandler(false,error)
                    return
                }
                completionHandler(true,nil)
                
            }
        }
        
    }
    private func remove() {
        
    }
    
}
// user services
extension User {
    internal func follow(userToFollow id: String, completionHandler: @escaping (Error?) -> Void) {
        let db = FireStoreManager.shared
        // add the user they wanna follow to the following list of current user
        db.followingCollection.document(currentId()).collection("user-followings").document(id).setData([:]) { error in
            guard error == nil else { return }
            db.followerCollection.document(id).collection("user-followers").document(self.currentId()).setData([:], completion: completionHandler)
        }
    }
    internal func unfollow(userToUnfollow id: String, completionHandler: @escaping (Error?) -> Void) {
        let db = FireStoreManager.shared
        // add the user they wanna follow to the following list of current user
        db.followingCollection.document(currentId()).collection("user-followings").document(id).delete{ error in
            db.followerCollection.document(id).collection("user-followers").document(self.currentId()).delete(completion: completionHandler)
        }
    }
    
    internal func getFollowersCount(completionHandler: @escaping (Int?) -> Void) {
        let db = FireStoreManager.shared
        db.followerCollection.document(id).collection("user-followers").getDocuments { snapshot, error in
            guard let count = snapshot?.count else { return }
            snapshot?.count
            completionHandler(count)
        }
    }
    
    internal func getFollowingsCount(completionHandler: @escaping (Int?) -> Void) {
        let db = FireStoreManager.shared
        db.followingCollection.document(id).collection("user-followings").getDocuments { snapshot, error in
            guard let count = snapshot?.count else { return }
            completionHandler(count)
        }
    }
    
    internal func fetchFollowings(completionHandler: @escaping ([User]?, Error?) -> Void ) {
        let db = FireStoreManager.shared
        db.followingCollection.document(id).collection("user-followings").getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error)");
                completionHandler(nil, error)
                return
            }
            var users = [User]()
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())");
                // fetch info for this following
                db.fetchUser(with: document.documentID) { user, error in
                    guard let user = user, error == nil else {
                        return
                    }
                    users.append(user)
                    completionHandler(users, nil)
                }
            }
        }
    }
    internal func fetchFollowers(completionHandler: @escaping ([User]?,Error?) -> Void ) {
        let db = FireStoreManager.shared
        db.followerCollection.document(id).collection("user-followers").getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error)");
                completionHandler(nil, error)
                return
            }
            var users = [User]()
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())");
                // fetch info for this follower
                db.fetchUser(with: document.documentID) { user, error in
                    guard let user = user, error == nil else {
                        return
                    }
                    users.append(user)
                    completionHandler(users, nil)
                }
            }
        }
    }
    internal func isFollowed(by userId: String = Authentication.shared.getCurrentUserUid()!, completionHandler: @escaping (Bool) -> Void) {
        let db = FireStoreManager.shared
        db.followingCollection.document(userId).collection("user-followings").document(self.id).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else { return }
            completionHandler(isFollowed)
        }
    }
    
    
    internal func showFeed(completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        var feedActivities = [Activity]()
        let db = FireStoreManager.shared
        db.followingCollection.document(id).collection("user-followings").getDocuments() { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error)");
                completionHandler(nil, error)
                return
            }
            for document in querySnapshot!.documents {
            
                // fetch activity for this following
                db.fetchActivities(filter: document.documentID) { activities, error in
                    if let activities = activities {
                        feedActivities.append(contentsOf: activities)
                        completionHandler(feedActivities,nil)
                    }
                }
            }
        }
    }
    func logout() -> Bool {
        return Authentication.shared.logout()
    }
}














