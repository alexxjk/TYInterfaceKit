import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TYInterfaceKitTests.allTests),
    ]
}
#endif
