//
//  UserDefaultsExtension.swift
//  Learnalize
//
//  Created by Media Davarkhah on 4/24/1401 AP.
//

import Foundation
extension UserDefaults {

    enum Keys: String, CaseIterable {
        
        case LoggedIn
        case currentUser
        
    }
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }

}
