//
//  ConverterViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Vikas Ahuja on 29/03/22.
//

import XCTest

@testable import CurrencyConverter

class ConverterViewModelTests: XCTestCase {
    
    fileprivate var service : MockCurrencyService!
    var viewModel : CurrencyConverterViewModel!
    var input:ConverterInput!
    
    override func setUp() {
        super.setUp()
        
        self.service = MockCurrencyService()
        viewModel = CurrencyConverterViewModel(service: self.service)
        input = ConverterInput(baseCurrency: "GBP", toCurrencies: "INR")
    }
    
    override func tearDown() {
        self.service = nil
        self.viewModel = nil
        self.input = nil
        super.tearDown()
    }
    
    func testFetchWithNoService(){
        let expectations = XCTestExpectation(description: "Missing service")
        viewModel.service = nil
        
        viewModel.errorHandling.observe(on: self) { (error) in
            expectations.fulfill()
        }
        
        viewModel.fetchCurrencies(input: input)
        wait(for:[expectations], timeout: 5.0)
    }
    
    func testFetchCurrencies() {
       
        let expectation = XCTestExpectation(description: "fetch currencies")
        service.converter = Converter(base: "GBP", date: "01-01-2018", amount: 1.0, rates: [])
                
        viewModel.updateView.observe(on: self) { _ in
            expectation.fulfill()
        }
        
        viewModel.fetchCurrencies(input: input)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchWithNoCurrenncies() {
        let expectation = XCTestExpectation(description: "No Currencies")
        service.converter = nil
        
        viewModel.errorHandling.observe(on: self) { (error) in
            expectation.fulfill()
        }
        
        viewModel.fetchCurrencies(input: input)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testGetToCurrencyAmount(){
        let rate = CurrencyRate(currencyIso: "INR", rate: 99)
        viewModel.converterModel = Converter(base: "GBP", date: "01-01-2018", amount: 1.0, rates: [rate])
        
        XCTAssertEqual(viewModel.getToCurrencyAmount(amount: 10), 990)
    }
    
}

    fileprivate class MockCurrencyService : CurrencyServiceProtocol {
        
        var converter : Converter?
        
        func fetchConverter(input: ConverterInput, completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
            
            if let converter = converter {
                completion(Result.success(converter))
            }else {
                completion(Result.failure(ErrorResult.custom))
            }
        }
        
    }
