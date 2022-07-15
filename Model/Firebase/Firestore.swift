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
            let fetchedUser =  Converter.DataToUser(dict: document.data()!)
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

    // MARK: -Activity related
    func save(activity: Activity, completionHandler: @escaping (Bool, Error?) -> Void){
       
        let userData = [
            "uid": activity.uid,
            "name": activity.name,
            "description": activity.description,
            "participantsLimit": activity.participantsLimit,
            "creationDate": activity.creationDate!,
            "hostId": activity.hostId!,
            "tagColor": activity.tagColor
        ] as [String : Any]
      
    
        FireStoreManager.shared.firestore.collection("activities").document(activity.uid).setData(userData) { error in
            if let error = error {
                completionHandler(true, error)
                return
            }
           
            completionHandler(true, nil)
        }
    }
   
    func fetchActivities(filter hostId: String, completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        let docRefs = firestore.collection("activities").whereField("hostId", in: [hostId]).limit(to: 10)
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            
            var activities = [Activity]()
            let docs = querySnapshot!.documents
            activities = docs.compactMap { queryDocumentSnapshot -> Activity? in
                
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
    func searchActivity(by name: String, completionHandler: @escaping ([Activity]?, Error?) -> Void) {
        let docRefs = firestore.collection("activities").whereField("name", in: [name]).limit(to: 10)
        docRefs.getDocuments { querySnapshot, error in
            guard error == nil else {
                completionHandler(nil,error)
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            
            var activities = [Activity]()
            let docs = querySnapshot!.documents
            activities = docs.compactMap { queryDocumentSnapshot -> Activity? in
                
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
        let docRefs = firestore.collection("users").whereField("username", in: [username]).limit(to: 5)
        
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

}
