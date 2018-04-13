import XCTest
import Testing
@testable import Vapor
@testable import App

class ScanSwitchTests: TestCase {
    func testInitWithValues() {
        let scanSwitch = ScanSwitch.init(shouldScan: true, roomID: 1, locationID: 2, storeData: false)
        XCTAssertEqual(scanSwitch.shouldScan, true)
        XCTAssertEqual(scanSwitch.roomID, 1)
        XCTAssertEqual(scanSwitch.locationID, 2)
        XCTAssertEqual(scanSwitch.storeData, false)
    }

    func testMakeRow() throws {
        let scanSwitch = ScanSwitch.init(shouldScan: true, roomID: 1, locationID: 2, storeData: false)
        let row = try scanSwitch.makeRow()
        XCTAssertEqual(try row.get("shouldScan"), true)
        XCTAssertEqual(try row.get("roomID"), 1)
        XCTAssertEqual(try row.get("locationID"), 2)
        XCTAssertEqual(try row.get("storeData"), false)
    }
}

extension ScanSwitchTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testInitWithValues", testInitWithValues),
        ("testMakeRow", testMakeRow),
    ]
}