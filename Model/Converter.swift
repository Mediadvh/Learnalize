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
    
    static func DataToActivity(dict: [String: Any]) -> Activity {
        let createdAt = dict["createdAt"] as? String ?? ""
        let description = dict["description"] as? String ?? ""
        let hostId = dict["hostId"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let participantsLimit = dict["participantsLimit"] as? Int ?? 1
        let uid = dict["uid"] as? String ?? ""
        let tagColor = dict["tagColor"] as? String ?? ""
        let active = dict["active"] as? Bool ?? true
        let participantsNumber = dict["participantsNumber"] as? Int ?? 0


        return Activity(name: name, description: description, participantsLimit: participantsLimit, tagColor: tagColor, createdAt: createdAt, uid: uid, active: active, hostId: hostId)
        
        
        
    }

    static func ActivityToData(activity: Activity) -> [String : Any] {
        return  ["createdAt": activity.createdAt,
                 "description": activity.description,
                 "hostId": activity.hostId,
                 "name": activity.name,
                 "participantsLimit": activity.participantsLimit,
                 "uid":activity.uid,
                 "tagColor": activity.tagColor,
                 "active": activity.active,
                 "participantsNumber": activity.participantsNumber]

    }
    
    static func ParticipatToData(participant: Participant) -> [String: Any] {
        return  ["role": participant.role.rawValue,
                 "askedForPermission": participant.askedForPermission,
                 "uid": participant.uid,
                 "peerId": participant.peerId]
    }
}
