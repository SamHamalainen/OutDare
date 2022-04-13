//
//  LeaderboardModel.swift
//  outdare
//
//  Created by Jasmin Partanen on 7.4.2022.
//

import Foundation
import Combine

// Observable to be added
final class LeaderboardModel: ObservableObject {
    @Published var users: [User] = load("userData.json")
    
    var sorted: [User] {
        users.sorted(by: { $0.score > $1.score })
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
