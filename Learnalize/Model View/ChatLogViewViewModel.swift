//
//  ChatLogViewViewModel.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/11/1401 AP.
//

import Foundation
extension ChatLogView {
    @MainActor class ViewModel: ObservableObject {
        @Published var text: String = ""
        @Published var messages = [Message]()
        @Published var receiver: User?
     
        @Published var count = 0
        
        init(receiver: User) {
            self.receiver = receiver
        
            guard let senderId = Authentication.shared.getCurrentUserUid() else { return }
            guard let receiverId = receiver.id else { return }
            FireStoreManager.shared.fetchMessages(senderId: senderId, receiverId: receiverId) { messages, error in
                guard let messages = messages , error == nil else { return }
                self.messages = messages
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
           
       
        }
       

        func send() {
            
           
            guard let senderId = Authentication.shared.getCurrentUserUid() else { return }
            
            guard let receiverId = receiver?.id else { return }
            // create the message
            let message = Message(text: text, sender: senderId, receiver: receiverId)
            text = ""
           // send the message
            message.send { success in
                if success {
                    print("sent the message successfully!")
                    self.count += 1
                }
            }
            
            
        }
    }
 
}
