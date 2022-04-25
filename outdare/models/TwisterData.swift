//
//  TwisterData.swift
//  outdare
//
//  Created by iosdev on 18.4.2022.
//

import SwiftUI

struct TwisterData {
    let timeLimit: Int
    let text: String
    var textArray: [String] {
        return text.components(separatedBy: " ")
    }
}

extension TwisterData {
    static let sample = [
        TwisterData(timeLimit: 30, text: "If two witches were watching two watches, which witch would watch which watch?"),
        TwisterData(timeLimit: 30, text: "The big black bug bit the big black bear, but the big black bear bit the big black bug back!"),
        TwisterData(timeLimit: 30, text: "The owner of the inside inn was inside his inside inn with his inside outside his inside inn.")
    ]
}

