//
//  Firestore.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/19/1401 AP.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

import FirebaseFirestoreSwift
enum collectionMode { case following, follower }
class FireStoreManager {
    
    static let shared = FireStoreManager()
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    let userCollection: CollectionReference
    let followerCollection: CollectionReference
    let followingCollection: CollectionReference
    private init() {
         auth = Auth.auth()
         storage = Storage.storage()
         firestore = Firestore.firestore()
         userCollection = firestore.collection("users")
         followerCollection = firestore.collection("followers")
         followingCollection = firestore.collection("followings")
        
    }
    
    //MARK: - User related
    func fetchUser(with userId: String,  completionHandler: @escaping (User?,Error?) -> Void) {
        
        let db = FireStoreManager.shared
        
        let docRef = db.userCollection.document(userId)
        
        docRef.getDocument { document, error in
            guard error == nil, let document = document else {
                print("Error getting document: \(error?.localizedDescription ?? "N/A")")
                return
            }
            // let decodedUser = try document.data(as: User.self)
            guard let data = document.data() else {
                print("Error getting document info: \(error?.localizedDescription ?? "N/A")")
                return
            }
            let fetchedUser =  Converter.DataToUser(dict: data)
            completionHandler(fetchedUser,nil)
        }
    }


    
 
    
    func getCount(of: collectionMode,id: String ,completionHandler: @escaping (Int?) -> Void) {
        var collection1: CollectionReference
        var collectionName2: String
        if of == .follower {
            collection1 = followerCollection
            collectionName2 = "user-followers"
        } else {
            collection1 = followingCollection
            collectionName2 = "user-following"
        }
        collection1.document(id).collection(collectionName2).getDocuments()
        {
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                var count = 0
                for _ in querySnapshot!.documents {
                    count += 1
//                    print("\(document.documentID) => \(document.data())");
                }
               completionHandler(count)
            }
        }
    }
    
    func updateCount(of: String, doc: String,newCount: Int, completionHandler: @escaping (Error?) -> Void) {
        
        self.firestore.collection(of).document(doc).updateData(["count": newCount]) { error in
            guard error == nil else {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
        
    }
    
    func deleteUser(with userId: String) {
        // delete the user
        firestore.collection("users").document(userId).delete { error in
            guard error == nil else {
                return
            }
            print("deleted user with userId: \(userId)")
        }
        // delete it from followers
        firestore.collection("followers").document(userId).delete { error in
            guard error == nil else {
                return
            }
            print("deleted user from followers with user id: \(userId)")
        }
        // delete it from followings
        firestore.collection("followings").document(userId).delete { error in
            guard error == nil else {
                return
            }
            print("deleted user from followings with user id: \(userId)")
        }
        // delete it from recent messages
        firestore.collection("recent_messages").document(userId).delete { error in
            guard error == nil else {
                return
            }
            print("deleted user from recent messages with user id: \(userId)")
        }
        // delete it from messages
        firestore.collection("messages").document(userId).delete { error in
            guard error == nil else {
                return
            }
            print("deleted user from messages with user id: \(userId)")
        }
        
        // delete activities made by it
        firestore.collection("activities").document(userId).delete { error in
            guard error == nil else {
                return
            }
            print("deleted user from activities with user id: \(userId)")
        }
    }

    // MARK: -Activity related
//    func save(activity: Activity, completionHandler: @escaping (Bool, Error?) -> Void){
//
//        let userData = [
//            "uid": activity.uid,
//            "name": activity.name,
//            "description": activity.description,
//            "participantsLimit": activity.participantsLimit,
//            "createdAt": activity.createdAt!,
//            "hostId": activity.hostId!,
//            "tagColor": activity.tagColor
//        ] as [String : Any]
//
//
//        FireStoreManager.shared.firestore.collection("activities").document(activity.uid).setData(userData) { error in
//            if let error = error {
//                completionHandler(true, error)
//                return
//            }
//
//            completionHandler(true, nil)
//        }
//    }
   
    func fetchActivities(filter hostId: String, completionHandler: @escaping ([Activity]?,Int?, Error?) -> Void) {
        let docRefs = firestore.collection("activities").whereField("hostId", in: [hostId]).limit(to: 2000 )
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            
            var activities = [Activity]()
            var activitysCount = 0
            let docs = querySnapshot!.documents
            activities = docs.compactMap { queryDocumentSnapshot -> Activity? in
                
                do {
                    activitysCount+=1
                    return try queryDocumentSnapshot.data(as: Activity.self)
                    
                } catch {
                    print(error)
                    completionHandler(nil,nil,error)
                    return nil
            
                }
            }
            completionHandler(activities,activitysCount,nil)
        }
    }
    func searchActivity(by name: String, completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        let docRefs = firestore.collection("activities").whereField("name", isGreaterThanOrEqualTo: name).whereField("name", isLessThan: name + "z").limit(to: 10)
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            
            var activities = [Activity]()
            let docs = querySnapshot!.documents
            activities = docs.compactMap { queryDocumentSnapshot in
                
                do {
                    return try queryDocumentSnapshot.data(as: Activity.self)

                } catch {
                    print(error)
                    completionHandler(nil,error)
                    return nil

                }
            }
            completionHandler(activities,nil)
        }
    }
    
    func searchUser(by username: String, completionHandler: @escaping ([User]?, Error?) -> Void) {
        
        let docRefs = firestore.collection("users").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThan: username + "z").limit(to: 10)

        
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            var users = [User]()
            if let docs = querySnapshot?.documents {
                users = docs.compactMap { queryDocumentSnapshot -> User? in
                    do {
                        return try queryDocumentSnapshot.data(as: User.self)
                    } catch {
                        print(error)
                        completionHandler(nil,error)
                        return nil
                    }
                }
                completionHandler(users,nil)
            }
            
        }
    }
//    
//    fileprivate func fetchActivitiesOf(_ querySnapshot: QuerySnapshot?, completionHandler: ([Activity]?, Error?) -> Void) {
//        var feedActivities = [Activity]()
//        for document in querySnapshot!.documents {
//            print("\(document.documentID) => \(document.data())");
//            // fetch activity for this following
//            fetchActivities(filter: document.documentID) { activities, error in
//                if let activities = activities {
//                    feedActivities.append(contentsOf: activities)
//                    completionHandler(feedActivities,nil)
//                }
//            }
//        }
//    }

    // MARK: -Chat related
   
    
    func fetchMessages(senderId: String, receiverId: String, completion: @escaping ([Message]?,Error?) -> Void) {
        var messages = [Message]()
        firestore.collection("messages").document(senderId).collection(receiverId).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("couldn't fetch messages")
                completion(nil,error)
                return
            }

            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let message = Message(data: data)
                    messages.append(message)
                }
            })
            
            completion(messages, nil)
            
        }
        
    }
    func fetchRecentMessages(userId: String, completion: @escaping ([Chat]?,Error?) -> Void) {
        var recentChat = [Chat]()
        firestore.collection("recent_messages").document(userId).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("couldn't fetch messages")
                completion(nil, error)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                let docId = change.document.documentID
                print("docId \(docId)")
//                                print("recentChat[0].uid \(recentChat[0].uid)")
//                                print("recentChat[0].id \(recentChat[0].id)")
                if let index = recentChat.firstIndex(where: { chat in
                    print(chat.id)
                    print(chat.uid)
                    return chat.uid == docId
                }) {
                    recentChat.remove(at: index)
                }
                
                
                let data = change.document.data()
                let message = Message(data: data)
                var recentId = message.senderId
                if message.senderId == userId {
                    recentId = message.receiverId
                }
                
                self.fetchUser(with: recentId) { user, error in
                    guard let user = user, error == nil else {
                        return
                    }
                   
                    var chat = Chat(uid: user.id, other: user, recentMessage: message)
                    
                    recentChat.append(chat)
                    completion(recentChat, nil)
                    
                }
                
            })
            
            
        }
    }
    
   
    
}
