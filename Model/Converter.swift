//
//  Converter.swift
//  Learnalize
//
//  Created by Media Davarkhah on 4/18/1401 AP.
//

import Foundation
struct Converter {
    static func DataToUser(dict: [String: Any]) -> User {
        
        let email = dict["email"] as? String ?? ""
        let fullName = dict["fullName"] as? String ?? ""
        let picture = dict["picture"] as? String ?? ""
        let username = dict["username"] as? String ?? ""
        let password = dict["password"] as? String ?? ""
        let id = dict["id"] as? String ?? ""
        
        return User(fullName: fullName , picture: picture, email: email, password: password, username: username, id: id)

    }
    static func UserToData(user: User) -> [String : String] {
        return  ["fullName": user.fullName, "picture": user.picture,"email": user.email,"password": user.password,"username": user.username,"id":user.id]

    }

}
