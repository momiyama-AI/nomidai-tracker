import Foundation
import SwiftData

@Model
final class PurchaseEntitlement {
    @Attribute(.unique) var id: UUID
    var productID: String
    var entitlementRawValue: String
    var isActive: Bool
    var expirationDate: Date?
    var latestTransactionID: String?
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        productID: String,
        entitlement: PurchaseEntitlementKind,
        isActive: Bool,
        expirationDate: Date? = nil,
        latestTransactionID: String? = nil,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.productID = productID
        self.entitlementRawValue = entitlement.rawValue
        self.isActive = isActive
        self.expirationDate = expirationDate
        self.latestTransactionID = latestTransactionID
        self.updatedAt = updatedAt
    }

    var entitlement: PurchaseEntitlementKind {
        get { PurchaseEntitlementKind(rawValue: entitlementRawValue) ?? .lifetime }
        set { entitlementRawValue = newValue.rawValue }
    }
}

