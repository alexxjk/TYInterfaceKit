import XCTest
@testable import TYInterfaceKit

final class TYInterfaceKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TYInterfaceKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
