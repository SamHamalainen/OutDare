//
//  User.swift
//  outdare
//
//  Created by Jasmin Partanen on 5.4.2022.
//
import Foundation
import SwiftUI

struct User: Hashable, Codable, Identifiable {
    var id: Int
    var username: String
    var score: Int
    var goneUp: Bool
    var profilePicture: String
}

struct CurrentUser: Hashable, Decodable, Identifiable {
    var id: String
    var username, location, email, profilePicture: String
    var score: Int
}
