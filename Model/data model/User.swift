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
    
    func editInfo(fullName: String? = nil, picture:UIImage? = nil ,email: String? = nil, password:String? = nil, username: String? = nil) {
        if let fullName = fullName {
            editFullname(fullname: fullName)
        }
        if let picture = picture {
           editPicture(image: picture)
            
        }
        if let email = email {
            editEmail(email: email)
            self.email = email
        }
        if let password = password {
            editPassword(password: password)
            self.password = password
        }
        if let username = username {
            editUsername(username: username)
            self.username = username
        }
     
    }
    
    private func editFullname(fullname: String) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.users).document(id).updateData(["fullName": fullname]) { error in
            guard error == nil else {
                print("DEBUG: couldn't edit full name \(String(describing: error?.localizedDescription))")
                return }
            self.fullName = fullname
            
        }
    }
    private func editUsername(username: String) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.users).document(id).updateData(["username": username]) { error in
            guard error == nil else {
                print("DEBUG: couldn't edit username \(String(describing: error?.localizedDescription))")
                return }
            self.username = username
            
        }
    }
    private func editPassword(password: String) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.users).document(id).updateData(["password": password]) { error in
            guard error == nil else {
                print("DEBUG: couldn't edit password \(String(describing: error?.localizedDescription))")
                return }
            self.password = password
            
            //TODO: should be changed in authentication
            
        }
    }
    private func editEmail(email: String) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.users).document(id).updateData(["email": email]) { error in
            guard error == nil else {
                print("DEBUG: couldn't edit email \(String(describing: error?.localizedDescription))")
                return }
            self.email = email
            
        }
    }
    private func editPicture(image: UIImage) {
        let db = FireStoreManager.shared.firestore
        self.saveProfileImage(image: image) { url, error in
            guard let url = url, error == nil else { return }
            db.collection(Collections.users).document(self.id).updateData(["picture": url.absoluteString]) { error in
                guard error == nil else {
                    print("DEBUG: couldn't edit picture \(String(describing: error?.localizedDescription))")
                    return }
                self.picture = url.absoluteString
                
            }
        }
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
        let db = FireStoreManager.shared.firestore
        let collectionRef = db.collection(Collections.users)
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
    internal func follow(userToFollow id: String, completionHandler: @escaping (Bool?,Error?) -> Void) {
        
//        isPrivate(userId: id) { res, error in
//            guard let res = res, error == nil else {
//                completionHandler(nil,error)
//                return
//            }
            
//            if res {
//                let db = FireStoreManager.shared
//                // add the user they wanna follow to the follow request list of the user
//                db.followRequestCollection.document(id).collection("user-follow-requests").document(self.currentId()).setData([:]) { error in
//                    guard error == nil else {
//                        completionHandler(nil,error)
//                        return
//                    }
//                    completionHandler(.requested,nil)
//                }
        //            } else {
        let db = FireStoreManager.shared.firestore
        // add the user they wanna follow to the following list of current user
        db.collection(Collections.followings).document(self.currentId()).collection(Collections.userFollowings).document(id).setData([:]) { error in
            guard error == nil else {
                completionHandler(nil,error)
                return
                
            }
            let curId = self.currentId()
            db.collection(Collections.followers).document(id).collection(Collections.userFollowers).document(curId).setData([:]) { error in
                guard error == nil else {
                    completionHandler(nil,error)
                    return
                    
                }
                completionHandler(true, error)
            }
            
        }
        //            }
    }
    
    
    internal func unfollow(userToUnfollow id: String, completionHandler: @escaping (Error?) -> Void) {
        let db = FireStoreManager.shared.firestore
        // add the user they wanna follow to the following list of current user
        db.collection(Collections.followings).document(currentId()).collection(Collections.userFollowings).document(id).delete{ error in
            db.collection(Collections.followers).document(id).collection(Collections.userFollowings).document(self.currentId()).delete(completion: completionHandler)
        }
    }
//    internal func removeFromRequests(userToRemove id: String = Authentication.shared.getCurrentUserUid()!, completionHandler: @escaping (Error?) -> Void) {
//        let db = FireStoreManager.shared
//        print("removing \(id) from \(self.id) requests")
//        // add the user they wanna follow to the following list of current user
//        db.followRequestCollection.document(self.id).collection("user-follow-requests").document(id).delete{ error in
//            completionHandler(error)
//        }
//    }
    
    internal func getFollowersCount(completionHandler: @escaping (Int?) -> Void) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.followers).document(id).collection(Collections.userFollowers).getDocuments { snapshot, error in
            guard let count = snapshot?.count else { return }
            snapshot?.count
            completionHandler(count)
        }
    }
    
    internal func getFollowingsCount(completionHandler: @escaping (Int?) -> Void) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.followings).document(id).collection(Collections.userFollowings).getDocuments { snapshot, error in
            guard let count = snapshot?.count else { return }
            completionHandler(count)
        }
    }
    
    internal func fetchFollowings(completionHandler: @escaping ([User]?,Int?, Error?) -> Void ) {
        var followingsCount = 0
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.followings).document(id).collection(Collections.userFollowings).getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error)");
                completionHandler(nil,nil, error)
                return
            }
            var users = [User]()
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())");
                // fetch info for this following
                FireStoreManager.shared.fetchUser(with: document.documentID) { user, error in
                    guard let user = user, error == nil else {
                        return
                    }
                    users.append(user)
                    followingsCount += 1
                    completionHandler(users,followingsCount, nil)
                }
            }
        }
    }
    internal func fetchFollowers(completionHandler: @escaping ([User]?,Int?,Error?) -> Void ) {
        var followersCount = 0
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.followers).document(id).collection(Collections.userFollowers).getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error)");
                completionHandler(nil,nil, error)
                return
            }
            var users = [User]()
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())");
                // fetch info for this follower
                FireStoreManager.shared.fetchUser(with: document.documentID) { user, error in
                    guard let user = user, error == nil else {
                        return
                    }
                    users.append(user)
                    followersCount+=1
                    completionHandler(users,followersCount, nil)
                }
            }
        }
    }
    internal func isFollowed(by userId: String = Authentication.shared.getCurrentUserUid()!, completionHandler: @escaping (Bool) -> Void) {
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.followings).document(userId).collection(Collections.userFollowings).document(self.id).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else {
                completionHandler(false)
                return
            }
            completionHandler(isFollowed)
        }
    }
//    internal func isRequestedToFollow(by userId: String = Authentication.shared.getCurrentUserUid()!, completionHandler: @escaping (Bool) -> Void) {
//        let db = FireStoreManager.shared
//
//        // first -> other
//        print(userId)
//        // second -> me
//        db.followRequestCollection.document(self.id).collection("user-follow-requests").document(userId).getDocument { snapshot, error in
//            guard let isRequested = snapshot?.exists else {
//
//                return
//            }
//            completionHandler(isRequested)
//        }
//
//    }
    
    internal func showFeed(completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        var feedActivities = [Activity]()
        let db = FireStoreManager.shared.firestore
        db.collection(Collections.followings).document(id).collection(Collections.userFollowings).getDocuments() { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error)");
                completionHandler(nil, error)
                return
            }
            for document in querySnapshot!.documents {
            
                // fetch activity for this following
                FireStoreManager.shared.fetchActivities(filter: document.documentID) { activities, _ ,error  in
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
    
//    func isPrivate(userId: String,completion: @escaping (Bool?, Error?) -> Void) {
//        let db = FireStoreManager.shared.firestore
//        db.collection("users").document(userId).getDocument { document, error in
//            guard error == nil, let document = document else {
//                print("Error getting document: \(error?.localizedDescription ?? "N/A")")
//                completion(nil, error)
//                return
//            }
//            // let decodedUser = try document.data(as: User.self)
//            guard let data = document.data() else {
//                print("Error getting document info: \(error?.localizedDescription ?? "N/A")")
//                completion(nil, error)
//                return
//            }
//            let fetchedUser =  Converter.DataToUser(dict: data)
//            if fetchedUser.visibility == "private" {
//                completion(true, nil)
//            } else {
//                completion(false, nil)
//            }
//
//        }
//    }
    
//    func addToFollowers(userToAdd id: String, completion: @escaping (Error?) -> Void) {
//
//        FireStoreManager.shared.followerCollection.document(self.currentId()).collection("user-followers").document(id).setData([:]) { error in
//            guard error == nil else {
//                completion(error)
//                return
//
//            }
//            completion(nil)
//        }
//    }
    
//    func hasRequestedToFollowCurrentUser(currentUser id: String = Authentication.shared.getCurrentUserUid()!) {
//     
//        
//        FireStoreManager.shared.followRequestCollection.document(id).collection("user-follow-requests").document(self.id)
//    }
}














