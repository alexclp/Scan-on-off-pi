import Vapor
import HTTP

final class ScanSwitchController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try ScanSwitch.all().makeJSON()
    }

    func store(_ req: Request) throws -> ResponseRepresentable {
        let scanSwitch = try req.createEntity()
        try scanSwitch.save()
        return scanSwitch
    }

    func show(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        return scanSwitch
    }

    func delete(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        try scanSwitch.delete()
        return Response(status: .ok)
    }

    func clear(_ req: Request) throws -> ResponseRepresentable {
        try ScanSwitch.makeQuery().delete()
        return Response(status: .ok)
    }

    func update(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try scanSwitch.update(for: req)

        // Save an return the updated post.
        try scanSwitch.save()
        return scanSwitch
    }

    func replace(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        let new = try req.createEntity()

        scanSwitch.shouldScan = new.shouldScan
        try scanSwitch.save()

        return scanSwitch
    }

    func makeResource() -> Resource<ScanSwitch> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func createEntity() throws -> ScanSwitch {
        guard let json = json else { throw Abort.badRequest }
        return try ScanSwitch(json: json)
    }
}

extension ScanSwitchController: EmptyInitializable { }
