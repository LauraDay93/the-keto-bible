import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private(set) var isConnected: Bool = false
    private(set) var isOnWifi: Bool = false
    private(set) var isOnCellular: Bool = false

    var onStatusChange: ((Bool) -> Void)?

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let connected = (path.status == .satisfied)
            self.isConnected = connected
            self.isOnWifi = path.usesInterfaceType(.wifi)
            self.isOnCellular = path.usesInterfaceType(.cellular)
            self.onStatusChange?(connected)
            // NotificationCenter.default.post(name: .networkStatusChanged, object: connected)
        }
        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}
