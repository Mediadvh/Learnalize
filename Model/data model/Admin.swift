//
//  Admin.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//

import Foundation
import UIKit
class Admin  {
    // MARK: properties
    private var email: String
    internal var password: String
    internal var uid: String
    internal var isAdmin: Bool
    // MARK: initializer
    init(email: String, password: String,uid: String, isAdmin: Bool = true) {
        self.uid = uid
        self.email = email
        self.password = password
        self.isAdmin = isAdmin
    }
    
    
}
