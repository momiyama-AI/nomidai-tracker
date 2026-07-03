import StoreKit
import SwiftData
import SwiftUI

struct PaywallView: View {
    @Environment(\.modelContext) private var modelContext

    let featureTitleKey: LocalizedStringKey?
    var onAccessChanged: () -> Void = {}

    @StateObject private var storeKitService = StoreKitService()
    @State private var isUnlocked = false

    init(featureTitleKey: LocalizedStringKey? = nil, onAccessChanged: @escaping () -> Void = {}) {
        self.featureTitleKey = featureTitleKey
        self.onAccessChanged = onAccessChanged
    }

    var body: some View {
        Form {
            if let featureTitleKey {
                Section {
                    Label {
                        Text(featureTitleKey)
                    } icon: {
                        Image(systemName: "lock.fill")
                    }
                }
            }

            Section {
                if isUnlocked {
                    Label {
                        Text("paywall.status.unlocked")
                    } icon: {
                        Image(systemName: "checkmark.seal.fill")
                    }
                    .foregroundStyle(.green)
                } else if storeKitService.isLoading {
                    ProgressView()
                } else if usesScreenshotProducts {
                    screenshotProductButton(
                        nameKey: "paywall.screenshot.lifetime.name",
                        descriptionKey: "paywall.screenshot.lifetime.description",
                        price: "¥600"
                    )
                    screenshotProductButton(
                        nameKey: "paywall.screenshot.monthly.name",
                        descriptionKey: "paywall.screenshot.monthly.description",
                        price: "¥200/月"
                    )
                } else if storeKitService.products.isEmpty {
                    Text("paywall.message.productsUnavailable")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(storeKitService.products, id: \.id) { product in
                        Button {
                            Task { await purchase(product) }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(product.displayName)
                                        .font(.body.weight(.semibold))
                                    Text(product.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(product.displayPrice)
                                    .font(.body.monospacedDigit())
                            }
                        }
                    }
                }
            } header: {
                Text("paywall.products.header")
            }

            if !isUnlocked {
                Section {
                    Text("paywall.subscription.disclosure")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("paywall.subscription.header")
                }
            }

            Section {
                Button {
                    Task { await restorePurchases() }
                } label: {
                    Label("paywall.restore", systemImage: "arrow.clockwise")
                }

                Link(destination: LegalLinks.termsURL) {
                    Label("paywall.terms", systemImage: "doc.text")
                }

                Link(destination: LegalLinks.privacyURL) {
                    Label("paywall.privacy", systemImage: "hand.raised")
                }
            }

            if let messageKey = storeKitService.messageKey, !usesScreenshotProducts {
                Section {
                    Text(LocalizedStringKey(messageKey))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(Text("paywall.title"))
        .task {
            await storeKitService.loadProducts()
            await refreshEntitlements()
        }
        .onAppear(perform: reloadAccess)
    }

    private var usesScreenshotProducts: Bool {
        #if DEBUG
        ScreenshotMode.isEnabled
        #else
        false
        #endif
    }

    private func screenshotProductButton(nameKey: LocalizedStringKey, descriptionKey: LocalizedStringKey, price: String) -> some View {
        Button {} label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(nameKey)
                        .font(.body.weight(.semibold))
                    Text(descriptionKey)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(price)
                    .font(.body.monospacedDigit())
            }
        }
    }

    private func purchase(_ product: Product) async {
        await storeKitService.purchase(product, context: modelContext)
        await refreshEntitlements()
    }

    private func restorePurchases() async {
        await storeKitService.restorePurchases(context: modelContext)
        await refreshEntitlements()
    }

    private func refreshEntitlements() async {
        await storeKitService.refreshEntitlements(context: modelContext)
        reloadAccess()
        try? WidgetSnapshotRefresher(context: modelContext).refresh(isMediumWidgetUnlocked: isUnlocked)
        onAccessChanged()
    }

    private func reloadAccess() {
        isUnlocked = (try? PurchaseEntitlementRepository(context: modelContext).isProUnlocked()) ?? false
    }
}

struct PremiumGateView<Content: View>: View {
    @Environment(\.modelContext) private var modelContext

    let featureTitleKey: LocalizedStringKey
    @ViewBuilder var content: () -> Content

    @State private var isUnlocked = false

    var body: some View {
        Group {
            if isUnlocked {
                content()
            } else {
                PaywallView(featureTitleKey: featureTitleKey, onAccessChanged: reloadAccess)
            }
        }
        .onAppear(perform: reloadAccess)
    }

    private func reloadAccess() {
        isUnlocked = (try? PurchaseEntitlementRepository(context: modelContext).isProUnlocked()) ?? false
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    return NavigationStack {
        PaywallView()
    }
    .modelContainer(container)
}
