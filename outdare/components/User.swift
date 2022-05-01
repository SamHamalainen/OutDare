//  User.swift
//  outdare
//  Created by Jasmin Partanen on 5.4.2022.
//  Description: User struct for storing user details

import Foundation
import SwiftUI

struct User: Hashable, Codable, Identifiable {
    var id: Int
    var username: String
    var score: Int
    var goneUp: Bool
    var profilePicture: String
}

// Struct for basic user profile
struct CurrentUser: Decodable, Identifiable {
    var id: String
    var username, location, email, profilePicture: String
    var score: Int
}
