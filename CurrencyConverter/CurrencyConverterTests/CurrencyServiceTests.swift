//
//  CurrencyServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Vikas Ahuja on 30/03/22.
//

import XCTest

@testable import CurrencyConverter

class CurrencyServiceTests: XCTestCase {

    func testCancelRequest(){
        
        CurrencyService.shared.cancelFetchCurrencies()
        XCTAssertNil(CurrencyService.shared.task, "Expect task nil")
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
