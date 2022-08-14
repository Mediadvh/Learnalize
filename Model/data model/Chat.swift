//
//  Chat.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/25/1401 AP.
//

import Foundation
import Firebase
struct Chat: Identifiable{
    // MARK: properties
    
    var id: String { uid }
    internal var uid: String
    internal var other: User
    internal var recentMessage: Message
    internal var timeAgo: String  {
        return convertTimeStampToSecondsAgo(timestamp: recentMessage.timeStamp)
    }
    
    
    // MARK: initializer
    init(uid: String,other: User, recentMessage: Message) {
        self.uid = uid
        self.other = other
        self.recentMessage = recentMessage
        
        
    }
    
    // MARK: methods
    
    
    func convertTimeStampToSecondsAgo(timestamp: Timestamp) -> String {
        
        print(timestamp)
        let timestampDate = Date(timeIntervalSince1970: Double(timestamp.seconds))
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
        
        var timeText = ""
        if diff.second! <= 0 {
            timeText = "Now"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
        }
        if diff.weekOfMonth! > 0 {
            timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
        }
        
        return timeText
        
    }
    
}
