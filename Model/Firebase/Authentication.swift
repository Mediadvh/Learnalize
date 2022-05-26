//
//  login.swift
//  Learnalize
//
//  Created by Media Davarkhah on 1/17/1401 AP.
//

import Firebase
struct Authentication {
    
    static let shared = Authentication()
    let auth: Auth

    private init() {
         auth = Auth.auth()
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.value(forKey: "LoggedIn") as? Bool ?? false
    }
   
    private func saveLoginInfo(with uid: String) {
        UserDefaults.standard.set(uid, forKey: "currentUser")
        UserDefaults.standard.set(true, forKey: "LoggedIn")
    }
    func getCurrentUserUid() -> String? {
        return UserDefaults.standard.value(forKey: "currentUser") as? String
    }
    func stayLoggedOut() {
        
    }
    func register(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
               
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
    func removeUser(user: User) {
        
    }
}
