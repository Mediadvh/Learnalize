//
//  Participant.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//

import Foundation
import UIKit
class Participant  {
    // MARK: properties
    internal var role: Role
    internal var askedForPermission: Bool
    internal var uid: String
  internal var peerId: String
    
//    private var cameraAccess: Bool
//    private var whiteBoardAccess: Bool
//    private var micAccess: Bool
//    private var joinDate: Date
//    // MARK: initializer
    init(role: Role, askedForPermission: Bool, uid: String) {
        self.role = role
        self.askedForPermission = askedForPermission
        self.uid = uid
        self.peerId = ""
        
    }
    
//    // MARK: methods
    internal func requestPermission(activityId: String) {
        // change asked for permission field to true
        FireStoreManager.shared.firestore.collection(Collections.activities).document(activityId).collection(Collections.participants).document(self.uid).updateData(["askedForPermission": true]) { error in
            guard error == nil else { return }
        }

    }
    
    internal func joinActivity(activityId: String) {
      
        let encodedParticipant = Converter.ParticipantToData(participant: self)
        
        FireStoreManager.shared.firestore.collection(Collections.activities).document(activityId).collection(Collections.participants).document(self.uid).setData(encodedParticipant) { error in
            guard error == nil else {
                return
            }
        }
        
        
    }
    internal func leaveActivity(activityId: String) {
        FireStoreManager.shared.firestore.collection(Collections.activities).document(activityId).collection(Collections.participants).document(self.uid).delete()
       
    }
    internal func storePeerId(activityId: String,id: String) {
        FireStoreManager.shared.firestore.collection(Collections.activities).document(activityId).collection(Collections.participants).document(self.uid).updateData(["peerId": id]) { error in
            print("peerId to store: \(id)")
            guard error == nil else {
                print("DEBUG: error occurred while trying to add peerId field: \(error?.localizedDescription)")
                return
            }
        }
    }
}
