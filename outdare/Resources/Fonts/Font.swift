//  Font.swift
//  outdare
//  Created by Jasmin Partanen on 7.4.2022.
//  Description: Initiating application font family
import Foundation
import SwiftUI


extension Font {
    static let customFont = CustomFont()
}

struct CustomFont {
    let smallText = Font.custom("JetBrainsMono-Regular", size: 12)
    let normalText = Font.custom("JetBrainsMono-Regular", size: 16)
    let largeText = Font.custom("JetBrainsMono-Bold", size: 22)
    let extraLargeText = Font.custom("JetBrainsMono-Bold", size: 28)
    let btnText = Font.custom("JetBrainsMono-Bold", size: 16)
    let challengeDescription = Font.custom("JetBrainsMono-Bold", size: 20)
    let countdown = Font.custom("JetBrainsMono-ExtraBold", size: 48)
    let appBarText = Font.custom("JetBrainsMono-ExtraBold", size: 18)
}
