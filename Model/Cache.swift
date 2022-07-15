//
//  Cache.swift
//  Learnalize
//
//  Created by Media Davarkhah on 4/19/1401 AP.
//

import Foundation
class Cache {
    static let shared = Cache()
    private var currentUser: User?
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    func setCurrentUser(user: User) {
        currentUser = user
    }
    private init() {
    }
}
