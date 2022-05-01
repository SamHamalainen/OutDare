//
//  navigationRouteTests.swift
//  outdareTests
//
//  Created by iosdev on 30.4.2022.
//

import XCTest
@testable import outdare
import CoreLocation

class navigationRouteTests: XCTestCase {
    let challenge1 = Challenge(id: 1, challengeId: 1, name: "Challenge1", difficulty: "easy", category: "quiz", description: "challenge1", coordinates: CLLocationCoordinate2D(latitude: 60.444333, longitude: 40.555888))
    let challenge2 = Challenge(id: 1, challengeId: 1, name: "Challenge2", difficulty: "hard", category: "quiz", description: "challenge2", coordinates: CLLocationCoordinate2D(latitude: 30.43242333, longitude: 46.5534588))
    
    var navigationRoute: NavigationRoute!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        navigationRoute = NavigationRoute()
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        navigationRoute = nil
    }
    
    func testExample() throws {
        navigationRoute.addDirections(from: CLLocationCoordinate2D(latitude: 60.444222, longitude: 40.555999), to: challenge1, option: .makeLast)
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            print("//this")
            XCTAssertEqual(self.navigationRoute.directionsArray.count, 1)
        }
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}

