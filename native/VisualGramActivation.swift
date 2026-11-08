import Foundation

// Open-source build: Visual features are available without server activation.
// This module preserves the public API for compatibility with existing code.

public struct VisualGramActivationGrant: Codable {
    public let v: Int
    public let device: String
    public let request: String
    public let server_time: Int64
    public let trial_until: Int64
    public let status: String
    public let lease_seconds: Int
}

public final class VisualGramActivation {
    public static let shared = VisualGramActivation()
    public static let changed = Notification.Name("VisualGramActivationChanged.v1")
    
    private init() {}
    
    // Open-source policy: visual features are always available locally.
    public var hasAccess: Bool {
        return true
    }
    
    public var statusText: String {
        return "Визуальные функции доступны"
    }
    
    // Preserved for compatibility with existing code that calls this on app launch.
    // In open-source build, this is a no-op.
    public func start(vendorIdentifier: String?, isForeground: Bool, activeNotification: Notification.Name, backgroundNotification: Notification.Name) {
        // No-op in open-source build
    }
}
