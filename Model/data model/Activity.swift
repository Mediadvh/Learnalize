
//  Activity.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//

import Foundation
struct Activity: Codable {
    // MARK: properties
    internal var creationDate: String!
    internal var description: String
    internal var hostId: String!
    internal var name: String
    internal var participantsLimit: Int
    internal var uid: String
    internal var tagColor: String
 
    
    // MARK: initializer
    init(uid: String,name: String, description: String, participantsLimit: Int, tagColor: String = "activityCard 1") {
        self.uid = uid
        self.name = name
        self.description = description
        self.participantsLimit = participantsLimit
        
        // assign current user id
        self.hostId = Authentication.shared.getCurrentUserUid()
      
        // creation date
        let date = Date.now
        let formattedDate = date.formatted(date: .complete, time: .omitted)
        self.creationDate = formattedDate
        self.tagColor = tagColor
        
    }
    // MARK: methods
    private func create() {
        // add to database
        //
    }
    private func end() {

    }
    private func remove() {

    }
}

extension Activity: Hashable {
    
}
