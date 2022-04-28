//
//  Directions.swift
//  outdare
//
//  Created by iosdev on 26.4.2022.
//

import Foundation
import CoreLocation
import MapKit

/// Directions object for the directions to the challenge
struct Directions: Identifiable {
    let id = UUID()
    let source: CLLocationCoordinate2D
    let destination: Challenge
    var mkRoute: MKRoute
}
/// Different options for how the directions are going to be added
enum DirectionsOption: Equatable {
    case makeFirst
    case makeLast
    case update
    case toIndex(Int)
}
