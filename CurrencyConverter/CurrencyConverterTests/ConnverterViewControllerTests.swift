//
//  ConnverterViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by Vikas Ahuja on 30/03/22.
//

import XCTest
import SnapshotTesting

@testable import CurrencyConverter

class ConnverterViewControllerTests: XCTestCase {

    let controllerName =  "ConverterViewController"
    var viewController : ConverterViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: controllerName, bundle: nil)
        
        viewController = storyboard.instantiateViewController(identifier: controllerName) as? ConverterViewController
    }

    override func tearDownWithError() throws {
        viewController = nil
    }

    //Snapshot test case
    func testDefaultState(){
        assertSnapshot(matching: viewController, as: .image(on: .iPhone12))
    }
    
}
