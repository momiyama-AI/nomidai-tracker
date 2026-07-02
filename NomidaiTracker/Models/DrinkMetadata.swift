import Foundation

enum DrinkCategory: String, CaseIterable, Codable, Identifiable {
    case beer
    case chuhai
    case highball
    case sake
    case wine
    case outside
    case custom

    var id: String { rawValue }
}

enum DrinkLocation: String, CaseIterable, Codable, Identifiable {
    case home
    case outside

    var id: String { rawValue }
}

enum AppTheme: String, CaseIterable, Codable, Identifiable {
    case system

    var id: String { rawValue }
}

enum PurchaseEntitlementKind: String, CaseIterable, Codable, Identifiable {
    case lifetime
    case monthly

    var id: String { rawValue }
}

