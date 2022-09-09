//
//  Text.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/25/1401 AP.
//

import Foundation
import Firebase
struct Message {
    // MARK: properties
    
    var text: String
    var senderId: String
    var receiverId: String
    var timeStamp: Timestamp!
    
    // MARK: initializers
    init(text: String, sender: String, receiver: String) {
        self.text = text
        self.senderId = sender
        self.receiverId = receiver
        self.timeStamp = Timestamp()
    }
    init(data: [String: Any]) {
        self.text = data["text"] as? String ?? ""
        self.senderId = data["senderId"] as? String ?? ""
        self.receiverId = data["receiverId"] as? String ?? ""
        self.timeStamp = data["timestamp"] as? Timestamp
        
    }
    // MARK: methods
    func send(completion: @escaping (Bool) -> Void) {
        
        guard let timeStamp = timeStamp else {
            completion(false)
            return
        }
        
        let db = FireStoreManager.shared.firestore
        let senderDocument = db.collection(Collections.messages).document(senderId).collection(receiverId).document()
       
        let messageData = ["senderId": senderId, "receiverId": receiverId, "text": text, "timestamp": timeStamp] as [String: Any]
        
        senderDocument.setData(messageData) { error in
            guard error == nil else {
                print("failed to save message into firebase")
                completion(false)
                return
                
            }
           print("successfully saved current user sending message!")
        }
        
        let recipientDocument = db.collection(Collections.messages).document(receiverId).collection(senderId).document()
       
        recipientDocument.setData(messageData) { error in
            guard error == nil else {
                print("failed to save message into firebase")
                completion(false)
                return
                
            }
            print("successfully saved recipient user receiving message!")
            completion(true)
            persistRecentMessage()
           
        }
        
        
    }
    func persistRecentMessage() {
        let db = FireStoreManager.shared.firestore
        let senderMsgData = ["uid": receiverId ,"timestamp": Timestamp(), "text": text, "senderId": senderId, "receiverId": receiverId] as [String: Any]
        
        let senderDoc = db.collection(Collections.recentMessages).document(senderId).collection(Collections.messages).document(receiverId)
        
        senderDoc.setData(senderMsgData) { error in
            guard error == nil else {
                print("DEBUG: could not persist message: \(error?.localizedDescription)" )
                return }
            
        }
        
        let recieverMsgData = ["uid": senderId ,"timestamp": Timestamp(), "text": text, "senderId": senderId, "receiverId": receiverId] as [String: Any]
        let receiverDoc = db.collection(Collections.recentMessages).document(receiverId).collection(Collections.messages).document(senderId)
        
        receiverDoc.setData(recieverMsgData) { error in
            guard error == nil else {
                print("DEBUG: could not persist message: \(error?.localizedDescription)" )
                return }
            
        }
        
    }
}
extension Message: Hashable {
    
}
