import Vapor
import FluentProvider
import HTTP

final class Measurement: Model {
    let storage = Storage()

    var signalStrength: Int
    var name: String
    var macAddress: String

    struct Keys {
        static let id = "id"
        static let signalStrength = "signalStrength"
        static let name = "name"
        static let macAddress = "macAddress"
    }

    init(signalStrength: Int, name: String, macAddress: String) {
        self.signalStrength = signalStrength
        self.name = name
        self.macAddress = macAddress
    }

    init(row: Row) throws {
        signalStrength = try row.get(Measurement.Keys.signalStrength)
        name = try row.get(Measurement.Keys.name)
        macAddress = try row.get(Measurement.Keys.macAddress)
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Measurement.Keys.signalStrength, signalStrength)
        try row.set(Measurement.Keys.name, name)
        try row.set(Measurement.Keys.macAddress, macAddress)
        return row
    }
}

extension Measurement: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.int(Measurement.Keys.signalStrength)
            builder.string(Measurement.Keys.name)
            builder.string(Measurement.Keys.macAddress)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Measurement: JSONConvertible {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Measurement.Keys.id, id)
        try json.set(Measurement.Keys.signalStrength, signalStrength)
        try json.set(Measurement.Keys.name, name)
        try json.set(Measurement.Keys.macAddress, macAddress)
        return json
    }
}

extension Measurement: JSONInitializable {
    convenience init(json: JSON) throws {
        self.init(
            signalStrength: try json.get(Measurement.Keys.signalStrength),
            name: try json.get(Measurement.Keys.name),
            macAddress: try json.get(Measurement.Keys.macAddress)
        )
    }
}

extension Measurement: ResponseRepresentable { }
