//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Vikas Ahuja on 24/03/22.
//

import XCTest

@testable import CurrencyConverter

class CurrencyConverterUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }
    
    func testCountriesLabels() throws {
        let fromCountrylabel =  app.staticTexts["From Country"]
        let toCountrylabel =  app.staticTexts["To Country"]
                
         XCTAssertTrue(fromCountrylabel.exists)
         XCTAssertTrue(toCountrylabel.exists)
    }
    
    
    func testConverterView_NavigationBar() throws{
        let searchText = "Currency Converter"
        XCTAssertTrue(app.otherElements["AccessibilityIdentifierConverterView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.navigationBars[searchText].waitForExistence(timeout: 5))
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
