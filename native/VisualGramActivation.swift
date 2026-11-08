import Foundation

// Open-source build: VisualGram visual features are available without
// mandatory activation, trial period, lifetime code, or server lease.
// This module keeps the public API for compatibility but implements a
// local always-granted access policy.

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

    // Open-source policy: visual features are always available locally.

    public var hasAccess: Bool {
        self.lock.lock(); defer { self.lock.unlock() }
        true
    }

    public var statusText: String {
        "Визуальные функции доступны (open-source сборка)"
    }



    private func identity() throws -> (SecKey, Data, String) {
        let tag = Data("app.visualgram.activation.secureenclave.v1".utf8)
        if self.key == nil {
            let query: [String: Any] = [kSecClass as String:kSecClassKey, kSecAttrApplicationTag as String:tag, kSecAttrKeyType as String:kSecAttrKeyTypeECSECPrimeRandom, kSecReturnRef as String:true]
            var found: CFTypeRef?
            let result = SecItemCopyMatching(query as CFDictionary, &found)
            if result == errSecSuccess, let found = found { self.key = (found as! SecKey) }
            else if result == errSecItemNotFound {
                guard let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, [.privateKeyUsage], nil) else { throw self.failure() }
                let attributes: [String: Any] = [kSecAttrKeyType as String:kSecAttrKeyTypeECSECPrimeRandom, kSecAttrKeySizeInBits as String:256, kSecAttrTokenID as String:kSecAttrTokenIDSecureEnclave, kSecPrivateKeyAttrs as String:[kSecAttrIsPermanent as String:true, kSecAttrApplicationTag as String:tag, kSecAttrAccessControl as String:access]]
                self.key = SecKeyCreateRandomKey(attributes as CFDictionary, nil)
            } else { throw self.failure() }
        }
        guard let key = self.key, let publicKey = SecKeyCopyPublicKey(key),
              let raw = SecKeyCopyExternalRepresentation(publicKey, nil) as Data?, raw.count == 65 else { throw self.failure() }
        if self.hint == nil {
            let query: [String:Any] = [kSecClass as String:kSecClassGenericPassword, kSecAttrService as String:"app.visualgram.activation.v1", kSecAttrAccount as String:"device-hint", kSecReturnData as String:true]
            var item: CFTypeRef?
            let result = SecItemCopyMatching(query as CFDictionary, &item)
            if result == errSecSuccess, let data = item as? Data, let text = String(data:data,encoding:.utf8), text.count == 64 {
                self.hint = text
            } else if result == errSecItemNotFound {
                let source = self.vendorIdentifier ?? UUID().uuidString
                let text = self.hex(Data(SHA256.hash(data:Data(("visualgram-v1:" + source).utf8))))
                var insert = query
                insert.removeValue(forKey:kSecReturnData as String)
                insert[kSecValueData as String] = Data(text.utf8)
                insert[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                guard SecItemAdd(insert as CFDictionary, nil) == errSecSuccess else { throw self.failure() }
                self.hint = text
            } else { throw self.failure() }
        }
        guard let hint = self.hint else { throw self.failure() }
        return (key, raw, hint)
    }

    private func hex(_ data: Data) -> String { return data.map { String(format:"%02x",$0) }.joined() }
    private func failure() -> NSError { return NSError(domain:"VisualGramActivation",code:1,userInfo:[NSLocalizedDescriptionKey:"Не удалось проверить доступ. Проверьте подключение и повторите."]) }


}