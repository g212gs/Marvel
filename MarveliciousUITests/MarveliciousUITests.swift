//
//  MarveliciousUITests.swift
//  MarveliciousUITests
//
//  Created by Gaurang Lathiya on 28/11/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import XCTest

class MarveliciousUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let app = XCUIApplication()
        sleep(10)
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["3-D Man"]/*[[".cells.staticTexts[\"3-D Man\"]",".staticTexts[\"3-D Man\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["3-D Man"].buttons["Back"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["A-Bomb (HAS)"]/*[[".cells.staticTexts[\"A-Bomb (HAS)\"]",".staticTexts[\"A-Bomb (HAS)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["A-Bomb (HAS)"].buttons["Back"].tap()
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
