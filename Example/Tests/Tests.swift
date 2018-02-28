import UIKit
import XCTest
@testable import paybear_ios

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Set Paybear API token
        Paybear.shared.setToken("pub9f2d5e3db59b6db40b57f83d9a33437f")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //    func testSetToken() {
    //        // This is an example of a functional test case.
    //        Paybear.shared.setToken("123")
    //        XCTAssert(Paybear.shared.token != nil)
    //    }
    
    func testGetCurrencies() {
        let expectation = XCTestExpectation(description: "Should get all currencies")
        
        Paybear.shared.getCurrencies { (currencies, error) in
            expectation.fulfill()
            if let currencies = currencies, error == nil {
                for currency in currencies {
                    
                }
            }
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
