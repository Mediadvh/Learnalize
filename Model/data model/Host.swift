//
//  Host.swift
//  Learnalize
//
//  Created by Media Davarkhah on 2/18/1401 AP.
//
//enum Tool: String  = do { case camera: String, case whiteBoard: String, case mic: String}

import Foundation
import UIKit
class Host: User {
    // MARK: properties
    internal var cameraIsOn: Bool
    internal var whiteBoardIsOn: Bool
    internal var micIsOn: Bool
    // MARK: initializer
    init(user: User,cameraIsOn: Bool, whiteBoardIsOn: Bool, micIsOn: Bool) {
       
        self.cameraIsOn = cameraIsOn
        self.whiteBoardIsOn = whiteBoardIsOn
        self.micIsOn = micIsOn
        
        super.init(fullName: user.fullName, picture: user.picture, email: user.email, password: user.password, username: user.username, id: user.id)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: methods
    private func grantAccess() {
        
    }
    private func turnOn(tool: String) {
        
    }
    private func turnOff(tool: String) {
        
    }
   
   
}
