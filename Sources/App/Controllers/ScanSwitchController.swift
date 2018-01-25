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

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/posts/13rd88' we should show that specific post
    func show(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        return scanSwitch
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'posts/l2jd9' we should remove that resource from the database
    func delete(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        try scanSwitch.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/posts' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try ScanSwitch.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try scanSwitch.update(for: req)

        // Save an return the updated post.
        try scanSwitch.save()
        return scanSwitch
    }

    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new Post with the same ID.
    func replace(_ req: Request, scanSwitch: ScanSwitch) throws -> ResponseRepresentable {
        // First attempt to create a new Post from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.createEntity()

        // Update the post with all of the properties from
        // the new post
        scanSwitch.shouldScan = new.shouldScan
        try scanSwitch.save()

        // Return the updated post
        return scanSwitch
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
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
    /// Create a post from the JSON body
    /// return BadRequest error if invalid
    /// or no JSON
    func createEntity() throws -> ScanSwitch {
        guard let json = json else { throw Abort.badRequest }
        return try ScanSwitch(json: json)
    }
}

/// Since PostController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension ScanSwitchController: EmptyInitializable { }
