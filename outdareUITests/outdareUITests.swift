//
//  outdareUITests.swift
//  outdareUITests
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import XCTest

class outdareUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testBuyingCoins() throws {
        let app = XCUIApplication()
        app.launch()

        let menuBtn = app.buttons["Menu button"]
        XCTAssertTrue(menuBtn.exists)
        menuBtn.tap()
        
        let menuItem = app.buttons["Store"]
        XCTAssertTrue(menuItem.exists)
        menuItem.tap()

        let megaCoins = app.buttons["Mega coins"].firstMatch
        XCTAssertTrue(megaCoins.exists)
        megaCoins.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssert(alert.exists, "Alert should exist")
        alert.buttons.element(boundBy: 1).tap()
        
        let poinstAdded = app.buttons["Points added"]
        XCTAssertTrue(poinstAdded.exists)
        poinstAdded.tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
