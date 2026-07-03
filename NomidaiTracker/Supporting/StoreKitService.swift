import Combine
import Foundation
import StoreKit
import SwiftData

@MainActor
final class StoreKitService: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published var messageKey: String?

    private let productIDs = [ProductIDs.lifetime, ProductIDs.monthly]

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            products = try await Product.products(for: productIDs)
                .sorted { lhs, rhs in
                    let leftIndex = productIDs.firstIndex(of: lhs.id) ?? productIDs.count
                    let rightIndex = productIDs.firstIndex(of: rhs.id) ?? productIDs.count
                    return leftIndex < rightIndex
                }
            if products.isEmpty {
                messageKey = "paywall.message.productsUnavailable"
            }
        } catch {
            messageKey = "paywall.message.productsUnavailable"
        }
    }

    func purchase(_ product: Product, context: ModelContext) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                guard let transaction = verifiedTransaction(from: verification) else {
                    messageKey = "paywall.message.unverified"
                    return
                }
                try cache(transaction: transaction, context: context)
                await transaction.finish()
                messageKey = "paywall.message.purchaseCompleted"
            case .pending:
                messageKey = "paywall.message.pending"
            case .userCancelled:
                break
            @unknown default:
                messageKey = "paywall.message.unknown"
            }
        } catch {
            messageKey = "paywall.message.purchaseFailed"
        }
    }

    func restorePurchases(context: ModelContext) async {
        do {
            try await AppStore.sync()
            await refreshEntitlements(context: context)
            messageKey = "paywall.message.restoreCompleted"
        } catch {
            messageKey = "paywall.message.restoreFailed"
        }
    }

    func refreshEntitlements(context: ModelContext) async {
        let repository = PurchaseEntitlementRepository(context: context)
        var activeProductIDs = Set<String>()

        for await verification in Transaction.currentEntitlements {
            guard let transaction = verifiedTransaction(from: verification) else { continue }
            do {
                try cache(transaction: transaction, context: context)
                activeProductIDs.insert(transaction.productID)
            } catch {
                messageKey = "paywall.message.entitlementFailed"
            }
        }

        do {
            try repository.deactivateMissing(productIDs: activeProductIDs)
        } catch {
            messageKey = "paywall.message.entitlementFailed"
        }
    }

    private func verifiedTransaction(from verification: VerificationResult<Transaction>) -> Transaction? {
        switch verification {
        case .verified(let transaction):
            return transaction
        case .unverified:
            return nil
        }
    }

    private func cache(transaction: Transaction, context: ModelContext) throws {
        let kind: PurchaseEntitlementKind = transaction.productID == ProductIDs.monthly ? .monthly : .lifetime
        let isActive = transaction.revocationDate == nil && (transaction.expirationDate.map { $0 > Date() } ?? true)
        try PurchaseEntitlementRepository(context: context).upsert(
            productID: transaction.productID,
            entitlement: kind,
            isActive: isActive,
            expirationDate: transaction.expirationDate,
            latestTransactionID: String(transaction.id)
        )
    }
}
