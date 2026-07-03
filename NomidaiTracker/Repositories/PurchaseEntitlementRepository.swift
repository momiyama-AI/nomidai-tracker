import Foundation
import SwiftData

struct PurchaseEntitlementRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func isProUnlocked(now: Date = .now) throws -> Bool {
        try activeEntitlements(now: now).isEmpty == false
    }

    func activeEntitlements(now: Date = .now) throws -> [PurchaseEntitlement] {
        let descriptor = FetchDescriptor<PurchaseEntitlement>()
        return try context.fetch(descriptor).filter { entitlement in
            entitlement.isActive && (entitlement.expirationDate.map { $0 > now } ?? true)
        }
    }

    func upsert(
        productID: String,
        entitlement: PurchaseEntitlementKind,
        isActive: Bool,
        expirationDate: Date?,
        latestTransactionID: String?,
        updatedAt: Date = .now
    ) throws {
        let descriptor = FetchDescriptor<PurchaseEntitlement>()
        let existing = try context.fetch(descriptor).first { $0.productID == productID }

        if let existing {
            existing.entitlement = entitlement
            existing.isActive = isActive
            existing.expirationDate = expirationDate
            existing.latestTransactionID = latestTransactionID
            existing.updatedAt = updatedAt
        } else {
            context.insert(
                PurchaseEntitlement(
                    productID: productID,
                    entitlement: entitlement,
                    isActive: isActive,
                    expirationDate: expirationDate,
                    latestTransactionID: latestTransactionID,
                    updatedAt: updatedAt
                )
            )
        }

        try context.save()
    }

    func deactivateMissing(productIDs activeProductIDs: Set<String>, updatedAt: Date = .now) throws {
        let descriptor = FetchDescriptor<PurchaseEntitlement>()
        let entitlements = try context.fetch(descriptor)
        for entitlement in entitlements where !activeProductIDs.contains(entitlement.productID) {
            entitlement.isActive = false
            entitlement.updatedAt = updatedAt
        }
        try context.save()
    }
}
