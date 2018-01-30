import Vapor
import FluentProvider
import HTTP

final class ScanSwitch: Model {
    let storage = Storage()

    // MARK: Properties and database keys

    var shouldScan: Bool
    var roomID: Int
    var locationID: Int

    struct Keys {
        static let id = "id"
        static let shouldScan = "shouldScan"
        static let roomID = "roomID"
        static let locationID = "locationID"
    }

    init(shouldScan: Bool, roomID: Int, locationID: Int) {
        self.shouldScan = shouldScan
        self.roomID = roomID
        self.locationID = locationID
    }

    // MARK: Fluent Serialization

    init(row: Row) throws {
        shouldScan = try row.get(ScanSwitch.Keys.shouldScan)
        roomID = try row.get(ScanSwitch.Keys.roomID)
        locationID = try row.get(ScanSwitch.Keys.locationID)
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ScanSwitch.Keys.shouldScan, shouldScan)
        try row.set(ScanSwitch.Keys.roomID, roomID)
        try row.set(ScanSwitch.Keys.locationID, locationID)
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
            builder.int(ScanSwitch.Keys.roomID)
            builder.int(ScanSwitch.Keys.locationID)
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
        try json.set(ScanSwitch.Keys.roomID, roomID)
        try json.set(ScanSwitch.Keys.locationID, locationID)
        return json
    }
}

extension ScanSwitch: JSONInitializable {
    convenience init(json: JSON) throws {
        self.init(
            shouldScan: try json.get(ScanSwitch.Keys.shouldScan),
            roomID: try json.get(ScanSwitch.Keys.roomID),
            locationID: try json.get(ScanSwitch.Keys.locationID)
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
            },
            UpdateableKey(ScanSwitch.Keys.roomID, Int.self) { scanSwitch, roomID in
                scanSwitch.roomID = roomID
            },
            UpdateableKey(ScanSwitch.Keys.locationID, Int.self) { scanSwitch, locationID in
                scanSwitch.locationID = locationID
            }
        ]
    }
}
