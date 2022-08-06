//
//  Chat.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/25/1401 AP.
//

import Foundation
import Firebase
struct Chat {
    // MARK: properties
    internal var other: User
    internal var recentMessage: Message
 
    
    
    // MARK: initializer
    init(other: User, recentMessage: Message) {
        self.other = other
        self.recentMessage = recentMessage
        
        
    }
    
    // MARK: methods
    
    
    
    
}
extension Chat: Identifiable {
    var id: ObjectIdentifier {
        return other.id
    }
    
   
    
}
