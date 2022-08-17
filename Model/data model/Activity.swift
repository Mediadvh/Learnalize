
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
        let activity = Converter.ActivityToData(activity: self)
      
    
        FireStoreManager.shared.firestore.collection("activities").document(uid).setData(activity) { error in
            if let error = error {
                completionHandler(true, error)
                return
            }
           
            completionHandler(true, nil)
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
        FireStoreManager.shared.firestore.collection("activities").document(uid).updateData(["participantsNumber": participantsNumber]) { error in
            guard error == nil else { return }
        }
    }
    func decreaseParticipantsNumber() {
        participantsNumber -= 1
        FireStoreManager.shared.firestore.collection("activities").document(uid).updateData(["participantsNumber": participantsNumber]) { error in
            guard error == nil else { return }
        }
    }
    
   
        // figure out a way to inform host by using change in document
    
}


extension Activity: Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(Activity.self)
    }
    
    
   
    
    
}
