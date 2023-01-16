//
//  ResponseTypes.swift
//  test-this better work
//
//  Created by Media Davarkhah on 5/3/1401 AP.
//

import Foundation
struct TokenResponse: Codable {
    let token: String
}

struct RoomResponse: Codable {
    let id: String
    let name: String
    let description: String
    let active: Bool
    let recording_source_template: Bool
    let user: String
    let customer: String
    let created_at: String
    let updated_at: String
}
