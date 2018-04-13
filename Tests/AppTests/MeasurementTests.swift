import XCTest
import Testing
@testable import Vapor
@testable import App

class MeasurementTests: TestCase {
    func testInitWithValues() {
        let measurement = Measurement.init(signalStrength: -20, name: "Test Name", macAddress: "AB:CD")
        XCTAssertEqual(measurement.signalStrength, -20)
        XCTAssertEqual(measurement.name, "Test Name")
        XCTAssertEqual(measurement.macAddress, "AB:CD")
    }

    func testMakeRow() throws {
        let measurement = Measurement.init(signalStrength: -20, name: "Test Name", macAddress: "AB:CD")
        let row = try measurement.makeRow()
        XCTAssertEqual(try row.get("signalStrength"), -20)
        XCTAssertEqual(try row.get("name"), "Test Name")
        XCTAssertEqual(try row.get("macAddress"), "AB:CD")
    }
}

extension MeasurementTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testInitWithValues", testInitWithValues),
        ("testMakeRow", testMakeRow),
    ]
}