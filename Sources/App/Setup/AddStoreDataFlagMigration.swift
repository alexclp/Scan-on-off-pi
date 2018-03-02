import Vapor
import FluentProvider

final class AddStoreDataFlagMigration: Preparation {
    static func prepare(_ database: Database) throws {
        try database.modify(ScanSwitch.self) { builder in
            builder.bool(ScanSwitch.Keys.storeData)
        }
    }
    
    static func revert(_ database: Database) throws { }
}