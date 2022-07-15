//
//  login.swift
//  Learnalize
//
//  Created by Media Davarkhah on 1/17/1401 AP.
//

import Firebase
import Foundation
struct Authentication {
    
    static let shared = Authentication()
    let auth: Auth

    private init() {
         auth = Auth.auth()
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.LoggedIn.rawValue) as? Bool ?? false
    }
   
    private func saveLoginInfo(with uid: String) {
        UserDefaults.standard.set(uid, forKey: UserDefaults.Keys.currentUser.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.LoggedIn.rawValue)
    }
    func getCurrentUserUid() -> String? {
        return UserDefaults.standard.value(forKey: "currentUser") as? String
    }
    func getCurrentUser(completionHandler: @escaping (User?, Error?) -> Void) {
        if let user = Cache.shared.getCurrentUser() {
            completionHandler(user,nil)
        } else {
            FireStoreManager.shared.fetchUser(with: getCurrentUserUid()!) { user, error in
                completionHandler(user,nil)
            }
        }
       
    }
    func stayLoggedOut() {
        
    }
    func register(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completionHandler(false)
            } else {
                let uid = auth.currentUser?.uid
                if let uid = uid {
                    saveLoginInfo(with: uid)
                    
                    completionHandler(true)
                }
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completionHandler(false)
            } else {
                let uid = auth.currentUser?.uid
                if let uid = uid {
                    saveLoginInfo(with: uid)
                    completionHandler(true)
                }
            }
        }
        
        
    }
    func logout() -> Bool {
        do {
            try auth.signOut()
            UserDefaults().reset()
            return true
        } catch {
            return false
        }
        
       
    }
  
}
