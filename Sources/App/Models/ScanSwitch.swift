import Vapor
import FluentProvider
import HTTP

final class ScanSwitch: Model {
    let storage = Storage()

    // MARK: Properties and database keys

    var shouldScan: Bool

    struct Keys {
        static let id = "id"
        static let shouldScan = "shouldScan"
    }

    init(shouldScan: Bool) {
        self.shouldScan = shouldScan
    }

    // MARK: Fluent Serialization

    init(row: Row) throws {
        shouldScan = try row.get(ScanSwitch.Keys.shouldScan)
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ScanSwitch.Keys.shouldScan, shouldScan)
        return row
    }
}

// MARK: Fluent Preparation

extension ScanSwitch: Preparation {
    /// Prepares a table/collection in the database
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.bool(ScanSwitch.Keys.shouldScan)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension ScanSwitch: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ScanSwitch.Keys.id, id)
        try json.set(ScanSwitch.Keys.shouldScan, shouldScan)
        return json
    }
}

extension ScanSwitch: JSONInitializable {
    convenience init(json: JSON) throws {
        self.init(
            shouldScan: try json.get(ScanSwitch.Keys.shouldScan)
        )
    }
}

// MARK: HTTP

extension ScanSwitch: ResponseRepresentable { }

// MARK: Update

extension ScanSwitch: Updateable {
    public static var updateableKeys: [UpdateableKey<ScanSwitch>] {
        return [
            UpdateableKey(ScanSwitch.Keys.shouldScan, Bool.self) { scanSwitch, shouldScan in
                scanSwitch.shouldScan = shouldScan
            }
        ]
    }
}
