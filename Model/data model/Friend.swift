//
//  Friend.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/25/1401 AP.
//

import Foundation
struct Friend {
    // MARK: properties
    var user1: User
    var user2: User
    var date: Date
    
    // MARK: initialiser
    init(user1: User, user2: User, date: Date = Date.now) {
        self.user1 = user1
        self.user2 = user2
        self.date = date
    }
    
    // MARK: methods
    func friend() {
        
    }
    func unfriend() {
        
    }
    
}
