import Vapor

extension Droplet {
    func setupRoutes() throws {
        try resource("scanSwitch", ScanSwitchController.self)
    }
}
