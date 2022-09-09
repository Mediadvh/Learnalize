
//  Activity.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//
import Foundation

class Activity: Codable {
    // MARK: properties
    internal var createdAt: String!
    internal var description: String
    internal var hostId: String! // first time it's created, add a host id to this
    internal var name: String
    internal var participantsLimit: Int
    internal var participantsNumber: Int
    internal var uid: String! // room id
    internal var tagColor: String
    internal var active: Bool = true
    internal var host: User?
//    internal var visibility: String?
    
    
    // MARK: initializer
    init(name: String, description: String, participantsLimit: Int, tagColor: String = "activityCard 1", createdAt: String, uid: String, active: Bool,hostId: String, host: User? = nil, participantsNumber: Int = 0) {
        self.name = name
        self.description = description
        self.participantsLimit = participantsLimit
        self.tagColor = tagColor
        self.createdAt = createdAt
        self.uid = uid
        self.active = active
        self.hostId = hostId
        if let host = host {
            self.host = host
        }
        self.participantsNumber = participantsNumber 
    }
    
    
    // MARK: methods
    internal func create(completionHandler: @escaping (Bool, Error?) -> Void) {
        
        
        FireStoreManager.shared.fetchUser(with: hostId) { user, error in
            guard let user = user else { return }
//            user.isPrivate(userId: user.id) { res, error in
//                guard let res = res else {
//                    return
//                }
//
//
//                if res {
//                    activity.visibility = "private"
//                } else {
//                    activity.visibility = "public"
//                }
            
            let activity = Converter.ActivityToData(activity: self)
            FireStoreManager.shared.firestore.collection(Collections.activities).document(self.uid).setData(activity) { error in
                if let error = error {
                    completionHandler(true, error)
                    return
                }
                
                completionHandler(true, nil)
            }
            //            }
            
           
        }
    
        
       
    }
    
   
    
   
    private func end() {

    }
    private func remove() {

    }
    func fetchHost(completion: @escaping (User?, Error?) -> Void ) {
        FireStoreManager.shared.fetchUser(with: hostId) { user, error in
            guard let user = user, error == nil else {
                completion(nil,error)
                return
            }
            self.host = user
            completion(user,nil)
        }
    }
    
 
    func increaseParticipantsNumber() {
        participantsNumber += 1
        FireStoreManager.shared.firestore.collection(Collections.activities).document(uid).updateData(["participantsNumber": participantsNumber]) { error in
            guard error == nil else { return }
        }
    }
    func decreaseParticipantsNumber() {
        participantsNumber -= 1
        FireStoreManager.shared.firestore.collection(Collections.activities).document(uid).updateData(["participantsNumber": participantsNumber]) { error in
            guard error == nil else { return }
        }
    }
    func deactivate() {
        FireStoreManager.shared.firestore.collection(Collections.activities).document(uid).updateData(["active": false]) { error in
            guard error == nil else { return }
        }
    }
    func acivityEnded(completion: @escaping (Bool) -> Void) {
        FireStoreManager.shared.firestore.collection(Collections.activities).document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
                completion(false)
              return
            }

            guard let data = document.data() else {
                   print("Document data was empty.")
                   completion(false)
                   return
                 }
            let activity = Converter.DataToActivity(dict: data)
           if  activity.active {
               completion(false)
           } else {
            completion(true)
           }
        }
    }
    
    func participantLeft(completion: @escaping (Bool) -> Void) {
        FireStoreManager.shared.firestore.collection(Collections.activities).document(uid).collection("participants").addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
              print("Error fetching document: \(error!)")
                completion(false)
              return
            }

            querySnapshot.documentChanges.forEach({ change in
                if change.type == .removed {
                    completion(true)
                }
            })
            
        }
    }
    
    func fetchParticipant(with peerId: String, completion: @escaping (User?, Error?) -> Void) {
        FireStoreManager.shared.firestore.collection(Collections.activities).document(uid).collection("participants").whereField("peerId", in: [peerId]).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot, error == nil else {
                completion(nil, error)
                return
            }
            querySnapshot.documents.compactMap { snapshot in
                let dict = snapshot.data()
                let uid = dict["uid"] as? String ?? ""
                FireStoreManager.shared.fetchUser(with: uid) { user, error in
                    guard let user = user,error == nil else {
                        completion(nil, error)
                        return
                    }
                    completion(user, nil)
                }
          
            }
            
        }
    }
        // figure out a way to inform host by using change in document
    
}


extension Activity: Identifiable {
    var id: String {
        return uid
    }
    
}
