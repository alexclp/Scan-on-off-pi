import Vapor
import FluentProvider
import HTTP

final class ScanSwitch: Model {
    let storage = Storage()

    // MARK: Properties and database keys

    /// The content of the post
    var shouldScan: Bool

    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let shouldScan = "shouldScan"
    }

    /// Creates a new Post
    init(shouldScan: Bool) {
        self.shouldScan = shouldScan
    }

    // MARK: Fluent Serialization

    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        shouldScan = try row.get(ScanSwitch.Keys.shouldScan)
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ScanSwitch.Keys.shouldScan, shouldScan)
        return row
    }
}

// MARK: Fluent Preparation

extension ScanSwitch: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
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

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
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

// This allows Post models to be returned
// directly in route closures
extension ScanSwitch: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension ScanSwitch: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<ScanSwitch>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(ScanSwitch.Keys.shouldScan, Bool.self) { scanSwitch, shouldScan in
                scanSwitch.shouldScan = shouldScan
            }
        ]
    }
}
