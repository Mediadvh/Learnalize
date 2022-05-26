//
//  User.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//

import Foundation
import UIKit
import SDWebImage

class User {
    // MARK: properties
    internal var fullName: String!
    internal var picture: String!
    internal var email: String!
    internal var password: String!
    internal var uid: String!
    internal var username: String!
    
    // MARK: initializer
    init(fullName: String, picture: String? ,email: String, password:String, username: String, uid: String) {
        self.fullName = fullName
        self.email = email
        self.password = password
        self.username = username
        self.uid = uid
        self.picture = picture
    }
   
    //MARK: methods
   

    func showInfo() {
        
    }
    
    func editInfo(fullName: String? = nil, picture:String? = nil ,email: String? = nil, password:String? = nil, username: String? = nil) {
        if let fullName = fullName {
            self.fullName = fullName
        }
        if let picture = picture {
            self.picture = picture
        }
        if let email = email {
            self.email = email
        }
        if let password = password {
            self.password = password
        }
        if let username = username {
            self.username = username
        }
        // update data base
    }
    
    private func saveImage(image: UIImage,completionHandler: @escaping (String) -> Void) {
        if !(self.picture == "profile") {
            FireStoreManager.shared.save(image: image) { url, error in
                if let error = error {
                    completionHandler(error.localizedDescription)
                }
                if let urlString = url?.absoluteString {
                    completionHandler(urlString)
                }
            }
        }
    }
    
    func save(with image: UIImage,completionHandler: @escaping (Bool, Error?) -> Void) {
        saveImage(image: image) { urlString in
            FireStoreManager.shared.save(user: self, with: urlString) { success, error in
                if success {
                   completionHandler(success,nil)
                } else {
                    completionHandler(success,nil)
                }
                
            }
        }
       
       
    }
    
    private func remove() {
        
    }
}
