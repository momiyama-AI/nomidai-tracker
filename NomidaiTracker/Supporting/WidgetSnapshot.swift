import Foundation

struct WidgetSnapshot: Codable, Equatable {
    let totalAmountYen: Int
    let remainingBudgetYen: Int?
    let dryDayCount: Int
    let wealthLevelRawValue: String
    let updatedAt: Date
    let isMediumWidgetUnlocked: Bool

    static let empty = WidgetSnapshot(
        totalAmountYen: 0,
        remainingBudgetYen: nil,
        dryDayCount: 0,
        wealthLevelRawValue: "grandRich",
        updatedAt: Date(timeIntervalSince1970: 0),
        isMediumWidgetUnlocked: false
    )
}

struct WidgetSnapshotStore {
    static let defaultKey = "widget.snapshot.v1"

    private let userDefaults: UserDefaults?
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        userDefaults: UserDefaults? = UserDefaults(suiteName: AppGroup.identifier),
        key: String = Self.defaultKey
    ) {
        self.userDefaults = userDefaults
        self.key = key

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func save(_ snapshot: WidgetSnapshot) throws {
        let data = try encoder.encode(snapshot)
        userDefaults?.set(data, forKey: key)
    }

    func load() -> WidgetSnapshot? {
        guard let data = userDefaults?.data(forKey: key) else { return nil }
        return try? decoder.decode(WidgetSnapshot.self, from: data)
    }
}
