//
//  RequestTypes.swift
//  test-this better work
//
//  Created by Media Davarkhah on 5/3/1401 AP.
//

import Foundation
struct RoomRequest: Codable {
    let name: String
    let description: String
    let template: String
}

struct AccessTokenRequest: Codable {
    let room_id: String
    let user_id: String
    let role: String
}
