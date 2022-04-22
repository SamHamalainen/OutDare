//
//  File.swift
//  outdare
//
//  Created by iosdev on 18.4.2022.
//

import Foundation

struct Twister {
    var id: Int = 0
    let data: [TwisterData]
}

extension Twister {
    static let sample = [
        Twister(data: TwisterData.sample)
    ]
}
