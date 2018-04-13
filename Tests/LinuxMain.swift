#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    // AppTests
    testCase(MeasurementTests.allTests),
    testCase(ScanSwitchTests.allTests),
])

#endif
