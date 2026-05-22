import AuthenticationServices
import Foundation
import Security
import SwiftUI
import WebKit

enum NexusSection: String, CaseIterable, Codable, Identifiable {
  case passwords
  case apiKeys
  case cards
  case subscriptions

  var id: String { rawValue }

  var title: String {
    switch self {
    case .passwords: return "PASSWORDS"
    case .apiKeys: return "API KEYS"
    case .cards: return "CARDS"
    case .subscriptions: return "RECURRINGS"
    }
  }

  var navIconPath: String {
    switch self {
    case .passwords: return "/shared/icons/passwords.png"
    case .apiKeys: return "/shared/icons/keys.png"
    case .cards: return "/shared/icons/cards.png"
    case .subscriptions: return "/shared/icons/recurrings.png"
    }
  }

  var resourceId: String { rawValue }
}

enum NexusTokens {
  static let gutter: CGFloat = 36
  static let control: CGFloat = gutter
  static let seam: CGFloat = 1
  static let modalActionGap: CGFloat = gutter
  static let modalLabelOffset: CGFloat = 8
  static let corner: CGFloat = 4
  static let grid: CGFloat = 32
  static let sidebarWidth: CGFloat = 220
  static let loggedOutBrandMin: CGFloat = 56
  static let loggedOutBrandMax: CGFloat = 88
  static let loggedOutBrandScale: CGFloat = 0.09
  static let loggedOutBrandTracking: CGFloat = -0.035
  static let loggedOutFieldWidth: CGFloat = 232
  static let loggedOutContentOffsetY: CGFloat = -25
  static let loggedOutActionGap: CGFloat = 39
  static let loggedOutSignInWidth: CGFloat = 94
  static let loggedOutCreateWidth: CGFloat = 98
  static let loggedOutFieldPadding: CGFloat = 14
  static let topBarHorizontalPadding: CGFloat = 18
  static let topBarVerticalPadding: CGFloat = 14
  static let toolbarRowGap: CGFloat = 24
  static let toolbarActionGap: CGFloat = 18
  static let mobileNavGap: CGFloat = 8
  static let mobileNavBottomPadding: CGFloat = 8
  static let navItemGap: CGFloat = 12
  static let navIconSize: CGFloat = 17
  static let buttonSymbolSize: CGFloat = 30
  static let pageDesktopHorizontalPadding: CGFloat = 28
  static let pageDesktopBottomPadding: CGFloat = 48
  static let pageMobileHorizontalPadding: CGFloat = 18
  static let pageMobileTopPadding: CGFloat = 24
  static let pageMobileBottomPadding: CGFloat = 40
  static let passwordsDesktopTopPadding: CGFloat = 34
  static let apiKeysDesktopTopPadding: CGFloat = 22
  static let defaultDesktopTopPadding: CGFloat = 30
  static let pageSectionGap: CGFloat = 30
  static let metricHorizontalGap: CGFloat = 48
  static let metricCompactGap: CGFloat = 16
  static let subscriptionsMetricGap: CGFloat = 38
  static let markerSize: CGFloat = 4
  static let metricBorderWidth: CGFloat = 2
  static let metricInset: CGFloat = 16
  static let subscriptionsMetricInset: CGFloat = 18
  static let tableHeaderVerticalPadding: CGFloat = 14
  static let tableCellHorizontalPadding: CGFloat = 16
  static let tableCellVerticalPadding: CGFloat = 14.4
  static let tableRowMinHeight: CGFloat = 54
  static let tableIconSize: CGFloat = 30
  static let tableCellGap: CGFloat = 8
  static let popupRowHeight: CGFloat = 48
  static let popupRowGap: CGFloat = 4
  static let popupRowPadding: CGFloat = 6
  static let boxedCellHeight: CGFloat = 28
  static let boxedCellHorizontalPadding: CGFloat = 10
  static let passwordsTableMinWidth: CGFloat = 960
  static let apiKeysTableMinWidth: CGFloat = 760
  static let cardsTableMinWidth: CGFloat = 980
  static let subscriptionsBoardMinWidth: CGFloat = 980
  static let subscriptionsBoardGap: CGFloat = 16
  static let subscriptionsRowGap: CGFloat = 13
  static let subscriptionsRowHorizontalPadding: CGFloat = 16
  static let subscriptionsRowVerticalPadding: CGFloat = 18
  static let border = Color.black.opacity(0.12)
  static let softBorder = Color.black.opacity(0.05)
  static let outlineSoft = Color.black.opacity(0.1)
  static let base = Color(red: 0.976, green: 0.976, blue: 0.976)
  static let panel = Color.white.opacity(0.86)
  static let passwordPanel = Color.white.opacity(0.78)
  static let cardPanel = Color.white.opacity(0.88)
  static let tableHeader = Color(red: 0.933, green: 0.933, blue: 0.933).opacity(0.94)
  static let tableHeaderPassword = Color(red: 0.933, green: 0.933, blue: 0.933).opacity(0.82)
  static let mutedPanel = Color(red: 0.953, green: 0.953, blue: 0.957)
  static let section = Color(red: 0.933, green: 0.933, blue: 0.933)
  static let strong = Color(red: 0.039, green: 0.039, blue: 0.039)
  static let muted = Color(red: 0.427, green: 0.427, blue: 0.427)
  static let body = Color(red: 0.102, green: 0.11, blue: 0.11)
  static let inputFont = Font.system(size: 13, weight: .regular, design: .default)
  static let labelFont = Font.system(size: 10, weight: .bold, design: .default).monospaced()
  static let rowFont = Font.system(size: 15, weight: .regular, design: .default)
  static let titleFont = Font.system(size: 42, weight: .semibold, design: .default)
  static let tableHeaderFont = Font.system(size: 10, weight: .bold, design: .default)
  static let tablePrimaryFont = Font.system(size: 15, weight: .bold, design: .default)
  static let tableSecondaryFont = Font.system(size: 14, weight: .regular, design: .default)
  static let tableMonoFont = Font.system(size: 14, weight: .regular, design: .default).monospacedDigit()
  static let metricLabelFont = Font.system(size: 10, weight: .bold, design: .default)
  static let metricValueFont = Font.system(size: 42, weight: .bold, design: .default)
  static let metricCompactValueFont = Font.system(size: 30, weight: .bold, design: .default)
  static let popupMetricTagFont = Font.system(size: 9, weight: .bold, design: .default)
  static let popupMetricValueFont = Font.system(size: 32, weight: .bold, design: .default)
  static let chipFont = Font.system(size: 10, weight: .bold, design: .default)
}

struct NexusEnvelope<Value: Decodable>: Decodable {
  let ok: Bool?
  let data: Value?
  let error: String?
}

struct NexusSession: Codable, Hashable {
  let authenticated: Bool
  let email: String
  let token: String?
  let unlocked: Bool?
}

struct NexusItemsPayload<Item: Decodable>: Decodable {
  let items: [Item]
}

struct NexusPassword: Codable, Identifiable, Hashable {
  let id: String
  let iconKey: String?
  let resolvedIconKey: String?
  let service: String?
  let username: String?
  let kinds: [String]?
  let rawSecret: String?
  let passwordMask: String?
  let website: String?
  let note: String?
  let resolvedIconUrl: String?
}

struct NexusAPIKey: Codable, Identifiable, Hashable {
  let id: String
  let keyName: String?
  let rawValue: String?
  let maskedValue: String?
  let environment: String?
  let note: String?
}

struct NexusCard: Codable, Identifiable, Hashable {
  let id: String
  let iconKey: String?
  let cardName: String?
  let network: String?
  let rawCardNumber: String?
  let maskedNumber: String?
  let creditCurrency: String?
  let creditLimit: Double?
  let expiry: String?
  let rawCvv: String?
  let cvvMask: String?
  let billingAnchorDate: String?
  let note: String?
  let resolvedIconUrl: String?
  let resolvedIconKey: String?
}

struct NexusRecurring: Codable, Identifiable, Hashable {
  let id: String
  let service: String?
  let iconKey: String?
  let tier: String?
  let cadence: String?
  let amountCurrency: String?
  let amount: Double?
  let billingAnchorDate: String?
  let status: String?
  let note: String?
  let resolvedIconUrl: String?
  let resolvedIconKey: String?
  let icon: String?
}

struct NexusMetricItem: Identifiable, Hashable {
  let label: String
  let value: String

  var id: String { label }
}

struct NexusTableColumn: Identifiable {
  let id: String
  let label: String
  let weight: CGFloat
  let alignment: Alignment

  init(_ id: String, _ label: String, weight: CGFloat, alignment: Alignment = .leading) {
    self.id = id
    self.label = label
    self.weight = weight
    self.alignment = alignment
  }
}

struct NexusVaultSnapshot: Codable, Hashable {
  var passwords: [NexusPassword] = []
  var apiKeys: [NexusAPIKey] = []
  var cards: [NexusCard] = []
  var subscriptions: [NexusRecurring] = []

  var sortedCards: [NexusCard] {
    cards.sorted(by: compareBillingDates)
  }

  var sortedSubscriptions: [NexusRecurring] {
    subscriptions.sorted(by: compareBillingDates)
  }

  var sortedPasswords: [NexusPassword] {
    passwords.sorted(by: comparePasswords)
  }

  var sortedAPIKeys: [NexusAPIKey] {
    apiKeys.sorted(by: compareAPIKeys)
  }

  var passwordMetrics: [NexusMetricItem] {
    let passwordBased = passwords.filter { $0.kinds?.contains("PASSWORD") == true }.count
    let oneTimeCodes = passwords.filter { row in
      row.kinds?.contains { $0 == "2FA" || $0 == "OTP" } == true
    }.count
    return [
      NexusMetricItem(label: "TOTAL ACCOUNTS", value: metricCount(passwords.count)),
      NexusMetricItem(label: "PASSWORD BASED", value: metricCount(passwordBased)),
      NexusMetricItem(label: "ONE-TIME-CODE", value: metricCount(oneTimeCodes))
    ]
  }

  var apiKeyMetrics: [NexusMetricItem] {
    let live = apiKeys.filter { clean($0.environment).uppercased() == "LIVE" }.count
    let internalCount = apiKeys.filter { clean($0.environment).uppercased() == "INTERNAL" }.count
    return [
      NexusMetricItem(label: "TOTAL KEYS", value: metricCount(apiKeys.count)),
      NexusMetricItem(label: "LIVE KEYS", value: metricCount(live)),
      NexusMetricItem(label: "INTERNAL", value: metricCount(internalCount))
    ]
  }

  var cardMetrics: [NexusMetricItem] {
    let nextBilling = sortedCards.compactMap { nextCardBillingDate($0) }.first
    return [
      NexusMetricItem(label: "TOTAL CARDS", value: metricCount(cards.count)),
      NexusMetricItem(
        label: "TOTAL CREDIT",
        value: currencyLines(
          cards,
          amount: { isNoCreditNetwork($0.network) ? 0 : $0.creditLimit ?? 0 },
          currency: { $0.creditCurrency ?? "USD" },
          digits: 0
        )
      ),
      NexusMetricItem(label: "NEXT BILLING", value: nextBilling.map(NexusDate.formatShort) ?? "N/A")
    ]
  }

  var subscriptionMetrics: [NexusMetricItem] {
    let billable = subscriptions.filter(isBillableSubscription)
    let activeCount = subscriptions.filter { clean($0.status).uppercased() == "ACTIVE" }.count
    let nextBilling = sortedSubscriptions.compactMap { nextSubscriptionBillingDate($0) }.first
    return [
      NexusMetricItem(
        label: "MONTHLY BURN",
        value: currencyLines(
          billable,
          amount: { monthlyAmount($0.amount ?? 0, cadence: $0.cadence) },
          currency: { $0.amountCurrency ?? "USD" },
          digits: 2
        )
      ),
      NexusMetricItem(label: "TOTAL ACTIVE", value: metricCount(activeCount)),
      NexusMetricItem(label: "NEXT BILLING", value: nextBilling.map(NexusDate.formatShort) ?? "N/A")
    ]
  }
}

#if DEBUG
extension NexusVaultSnapshot {
  static let mock = NexusVaultSnapshot(
    passwords: [
      NexusPassword(
        id: "mock-password-apple",
        iconKey: "apple.com",
        resolvedIconKey: "apple.com",
        service: "Apple",
        username: "zjz.one@outlook.com",
        kinds: ["PASSWORD", "OTP"],
        rawSecret: "mock-password",
        passwordMask: "••••••••••••",
        website: "apple.com",
        note: "Primary",
        resolvedIconUrl: ""
      ),
      NexusPassword(
        id: "mock-password-openai",
        iconKey: "openai.com",
        resolvedIconKey: "openai.com",
        service: "OpenAI",
        username: "zjz.one",
        kinds: ["PASSWORD"],
        rawSecret: "mock-password",
        passwordMask: "••••••••",
        website: "openai.com",
        note: "Work",
        resolvedIconUrl: ""
      )
    ],
    apiKeys: [
      NexusAPIKey(
        id: "mock-api-live",
        keyName: "Nexus Worker",
        rawValue: "sk_live_mock",
        maskedValue: "sk_live_••••••••",
        environment: "LIVE",
        note: "Cloudflare"
      ),
      NexusAPIKey(
        id: "mock-api-internal",
        keyName: "Local Admin",
        rawValue: "sk_internal_mock",
        maskedValue: "sk_internal_••••",
        environment: "INTERNAL",
        note: "Dev"
      )
    ],
    cards: [
      NexusCard(
        id: "mock-card-amex",
        iconKey: "americanexpress.com",
        cardName: "Amex Platinum",
        network: "AMEX",
        rawCardNumber: "",
        maskedNumber: "•••• 1007",
        creditCurrency: "USD",
        creditLimit: 12000,
        expiry: "08/29",
        rawCvv: "",
        cvvMask: "••••",
        billingAnchorDate: "2026-05-28",
        note: "Travel",
        resolvedIconUrl: "",
        resolvedIconKey: ""
      ),
      NexusCard(
        id: "mock-card-visa",
        iconKey: "",
        cardName: "RBC Visa",
        network: "VISA",
        rawCardNumber: "",
        maskedNumber: "•••• 4242",
        creditCurrency: "CAD",
        creditLimit: 8000,
        expiry: "11/28",
        rawCvv: "",
        cvvMask: "•••",
        billingAnchorDate: "2026-06-02",
        note: "Daily",
        resolvedIconUrl: "",
        resolvedIconKey: ""
      )
    ],
    subscriptions: [
      NexusRecurring(
        id: "mock-recurring-openai",
        service: "OpenAI",
        iconKey: "openai.com",
        tier: "PLUS",
        cadence: "MONTHLY",
        amountCurrency: "USD",
        amount: 20,
        billingAnchorDate: "2026-05-25",
        status: "ACTIVE",
        note: "AI",
        resolvedIconUrl: "",
        resolvedIconKey: "",
        icon: ""
      ),
      NexusRecurring(
        id: "mock-recurring-apple",
        service: "iCloud",
        iconKey: "apple.com",
        tier: "2TB",
        cadence: "YEARLY",
        amountCurrency: "CNY",
        amount: 198,
        billingAnchorDate: "2026-06-12",
        status: "ACTIVE",
        note: "Storage",
        resolvedIconUrl: "",
        resolvedIconKey: "",
        icon: ""
      )
    ]
  )
}
#endif

private func clean(_ value: String?) -> String {
  let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
  return normalized.isEmpty ? "-" : normalized
}

private func emptyToBlank(_ value: String?) -> String {
  let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
  return normalized
}

private func metricCount(_ value: Int) -> String {
  String(format: "%02d", max(0, value))
}

private func compareBillingDates(_ left: NexusCard, _ right: NexusCard) -> Bool {
  billingSortStamp(nextCardBillingDate(left)) < billingSortStamp(nextCardBillingDate(right))
}

private func compareBillingDates(_ left: NexusRecurring, _ right: NexusRecurring) -> Bool {
  billingSortStamp(nextSubscriptionBillingDate(left)) < billingSortStamp(nextSubscriptionBillingDate(right))
}

private func comparePasswords(_ left: NexusPassword, _ right: NexusPassword) -> Bool {
  compareTextChain(
    (left.service, right.service),
    (left.username, right.username),
    (left.website, right.website),
    (left.id, right.id)
  )
}

private func compareAPIKeys(_ left: NexusAPIKey, _ right: NexusAPIKey) -> Bool {
  compareTextChain(
    (left.keyName, right.keyName),
    (left.note, right.note),
    (left.id, right.id)
  )
}

private func compareTextChain(_ pairs: (String?, String?)...) -> Bool {
  for pair in pairs {
    let comparison = emptyToBlank(pair.0).localizedStandardCompare(emptyToBlank(pair.1))
    if comparison == .orderedAscending { return true }
    if comparison == .orderedDescending { return false }
  }
  return false
}

private func billingSortStamp(_ date: Date?) -> TimeInterval {
  date?.timeIntervalSince1970 ?? .greatestFiniteMagnitude
}

private func isNoCreditNetwork(_ value: String?) -> Bool {
  let normalized = clean(value).uppercased()
  return normalized == "DEBIT" || normalized == "VIRTUAL"
}

private func cadenceMonths(_ value: String?) -> Int {
  switch clean(value).uppercased() {
  case "QUARTERLY", "QUARTER":
    return 3
  case "YEARLY", "ANNUAL", "ANNUALLY":
    return 12
  case "MONTHLY":
    return 1
  default:
    return 0
  }
}

private func nextCardBillingDate(_ card: NexusCard, now: Date = Date()) -> Date? {
  guard !isNoCreditNetwork(card.network), let anchor = NexusDate.dateOnly(card.billingAnchorDate) else {
    return nil
  }
  return advanceBillingDate(anchorDate: anchor, cadenceMonths: 1, now: now)
}

private func nextSubscriptionBillingDate(_ recurring: NexusRecurring, now: Date = Date()) -> Date? {
  guard clean(recurring.status).uppercased() != "INACTIVE",
    let anchor = NexusDate.dateOnly(recurring.billingAnchorDate)
  else {
    return nil
  }
  let months = cadenceMonths(recurring.cadence)
  guard months > 0 else { return nil }
  return advanceBillingDate(anchorDate: anchor, cadenceMonths: months, now: now)
}

private func isBillableSubscription(_ recurring: NexusRecurring) -> Bool {
  guard clean(recurring.status).uppercased() == "ACTIVE" else { return false }
  guard clean(recurring.tier).uppercased() == "FREE TRIAL" else { return true }
  guard let anchor = NexusDate.dateOnly(recurring.billingAnchorDate) else { return false }
  return anchor <= Calendar(identifier: .gregorian).startOfDay(for: Date())
}

private func advanceBillingDate(anchorDate: Date, cadenceMonths: Int, now: Date) -> Date? {
  guard cadenceMonths > 0 else { return nil }
  let calendar = Calendar(identifier: .gregorian)
  let today = calendar.startOfDay(for: now)
  let anchorDay = calendar.component(.day, from: anchorDate)
  var current = calendar.startOfDay(for: anchorDate)
  while current < today {
    guard let next = anchoredDate(after: current, cadenceMonths: cadenceMonths, anchorDay: anchorDay) else {
      return nil
    }
    current = next
  }
  return current
}

private func anchoredDate(after date: Date, cadenceMonths: Int, anchorDay: Int) -> Date? {
  let calendar = Calendar(identifier: .gregorian)
  let monthStartComponents = calendar.dateComponents([.year, .month], from: date)
  guard let monthStart = calendar.date(from: monthStartComponents),
    let nextMonthStart = calendar.date(byAdding: .month, value: cadenceMonths, to: monthStart),
    let dayRange = calendar.range(of: .day, in: .month, for: nextMonthStart)
  else {
    return nil
  }
  var nextComponents = calendar.dateComponents([.year, .month], from: nextMonthStart)
  nextComponents.day = min(anchorDay, dayRange.count)
  return calendar.date(from: nextComponents).map { calendar.startOfDay(for: $0) }
}

private func monthlyAmount(_ amount: Double, cadence: String?) -> Double {
  switch String(cadence ?? "MONTHLY").uppercased() {
  case "YEARLY", "ANNUAL", "ANNUALLY":
    return amount / 12
  case "QUARTERLY", "QUARTER":
    return amount / 3
  default:
    return amount
  }
}

private func currencyLines<Item>(
  _ items: [Item],
  amount: (Item) -> Double,
  currency: (Item) -> String,
  digits: Int
) -> String {
  let totals = Dictionary(grouping: items, by: currency).mapValues { rows in
    rows.reduce(0) { $0 + amount($1) }
  }
  let ordered = ["USD", "CAD", "CNY"].compactMap { code -> String? in
    guard let value = totals[code], abs(value) > 0.000_001 else { return nil }
    return NexusCurrency.format(value, currency: code, digits: digits)
  }
  return ordered.isEmpty ? NexusCurrency.format(0, currency: "USD", digits: digits) : ordered.joined(separator: "\n")
}

enum NexusCurrency {
  static func format(_ value: Double, currency: String, digits: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currency == "JPY" ? "CNY" : currency
    formatter.minimumFractionDigits = digits
    formatter.maximumFractionDigits = digits
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
}

enum NexusDate {
  static func stamp(_ value: String?) -> TimeInterval {
    guard let date = dateOnly(value) else { return .greatestFiniteMagnitude }
    return date.timeIntervalSince1970
  }

  static func formatShort(_ value: String) -> String {
    guard let date = dateOnly(value) else { return value }
    return formatShort(date)
  }

  static func formatShort(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MMM dd"
    return formatter.string(from: date).uppercased()
  }

  static func dateOnly(_ value: String?) -> Date? {
    let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    guard !normalized.isEmpty else { return nil }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.date(from: normalized)
  }
}

enum NexusHost {
  static func normalize(_ value: String?) -> String {
    let raw = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !raw.isEmpty else { return "" }
    let url = URL(string: raw.contains("://") ? raw : "https://\(raw)")
    return removeCommonPrefix(url?.host ?? raw)
  }

  private static func removeCommonPrefix(_ value: String) -> String {
    value.hasPrefix("www.") ? String(value.dropFirst(4)) : value
  }
}

actor NexusAPIClient {
  private let baseURL: URL
  private let decoder = JSONDecoder()

  init(baseURL: URL = NexusEnvironment.baseURL) {
    self.baseURL = baseURL
  }

  func session() async throws -> NexusSession {
    try await request("/api/session", method: "GET", body: Optional<Data>.none)
  }

  func login(email: String, password: String) async throws -> NexusSession {
    let body = try JSONEncoder().encode(["email": email, "password": password])
    let session: NexusSession = try await request("/api/auth/login", method: "POST", body: body)
    if let token = session.token, !token.isEmpty {
      try? NexusSecureStore.saveString(token, account: NexusSecureStore.sessionAccount)
    }
    return session
  }

  func register(email: String, password: String) async throws -> NexusSession {
    let body = try JSONEncoder().encode(["email": email, "password": password])
    let session: NexusSession = try await request("/api/auth/register", method: "POST", body: body)
    if let token = session.token, !token.isEmpty {
      try? NexusSecureStore.saveString(token, account: NexusSecureStore.sessionAccount)
    }
    return session
  }

  func logout() async throws {
    let _: NexusSession = try await request("/api/auth/logout", method: "POST", body: Optional<Data>.none)
    try? NexusSecureStore.delete(account: NexusSecureStore.sessionAccount)
    try? NexusCredentialCache.save([])
  }

  func vault() async throws -> NexusVaultSnapshot {
    let passwords: [NexusPassword] = try await items(.passwords)
    let apiKeys: [NexusAPIKey] = try await items(.apiKeys)
    let cards: [NexusCard] = try await items(.cards)
    let subscriptions: [NexusRecurring] = try await items(.subscriptions)
    return NexusVaultSnapshot(
      passwords: passwords,
      apiKeys: apiKeys,
      cards: cards,
      subscriptions: subscriptions
    )
  }

  private func items<Item: Decodable>(_ section: NexusSection) async throws -> [Item] {
    let path = "/api/nexus/items?resource=\(section.resourceId)"
    let payload: NexusItemsPayload<Item> = try await request(path, method: "GET", body: Optional<Data>.none)
    return payload.items
  }

  private func request<Value: Decodable>(_ path: String, method: String, body: Data?) async throws -> Value {
    let root = baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    let suffix = path.hasPrefix("/") ? path : "/\(path)"
    guard let url = URL(string: root + suffix) else {
      throw NexusError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = try? NexusSecureStore.readString(account: NexusSecureStore.sessionAccount), !token.isEmpty {
      request.setValue(token, forHTTPHeaderField: "x-session-token")
    }
    request.httpBody = body
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let http = response as? HTTPURLResponse else {
      throw NexusError.invalidResponse
    }
    let envelope = try decoder.decode(NexusEnvelope<Value>.self, from: data)
    guard (200..<300).contains(http.statusCode), envelope.ok != false, let value = envelope.data else {
      throw NexusError.requestFailed(envelope.error ?? "Request failed.")
    }
    if let session = value as? NexusSession, let token = session.token, !token.isEmpty {
      try? NexusSecureStore.saveString(token, account: NexusSecureStore.sessionAccount)
    }
    return value
  }
}

enum NexusError: LocalizedError {
  case invalidURL
  case invalidResponse
  case requestFailed(String)
  case secureStore(OSStatus)
  case locked

  var errorDescription: String? {
    switch self {
    case .invalidURL: return "Invalid URL."
    case .invalidResponse: return "Invalid response."
    case .requestFailed(let message): return message
    case .secureStore(let status): return "Keychain error \(status)."
    case .locked: return "Nexus is locked."
    }
  }
}

enum NexusEnvironment {
  static var baseURL: URL {
    let raw = Bundle.main.object(forInfoDictionaryKey: "NexusBaseURL") as? String
    return URL(string: raw ?? "https://zjz.world/nexus")!
  }

  #if DEBUG
  static var usesMockVault: Bool {
    ProcessInfo.processInfo.arguments.contains("--nexus-mock-vault")
  }
  #endif

  static var appGroup: String? {
    cleanSetting(Bundle.main.object(forInfoDictionaryKey: "NexusAppGroup") as? String)
  }

  static var keychainAccessGroup: String? {
    cleanSetting(Bundle.main.object(forInfoDictionaryKey: "NexusKeychainAccessGroup") as? String)
  }

  private static func cleanSetting(_ value: String?) -> String? {
    let normalized = String(value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    guard !normalized.isEmpty, !normalized.contains("$(") else { return nil }
    return normalized
  }
}

enum NexusSecureStore {
  static let sessionAccount = "session-token"
  static let credentialCacheAccount = "credential-cache"
  private static let service = "one.zjz.nexus"
  private static let missingEntitlementStatus: OSStatus = -34018

  static func saveString(_ value: String, account: String) throws {
    try save(Data(value.utf8), account: account)
  }

  static func readString(account: String) throws -> String? {
    guard let data = try read(account: account) else { return nil }
    return String(data: data, encoding: .utf8)
  }

  static func save(_ data: Data, account: String) throws {
    var lastStatus: OSStatus = errSecSuccess
    for var query in candidateQueries(account: account) {
      SecItemDelete(query as CFDictionary)
      query[kSecValueData as String] = data
      query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      let status = SecItemAdd(query as CFDictionary, nil)
      if status == errSecSuccess { return }
      lastStatus = status
      if status != missingEntitlementStatus { break }
    }
    throw NexusError.secureStore(lastStatus)
  }

  static func read(account: String) throws -> Data? {
    var lastStatus: OSStatus = errSecSuccess
    for var query in candidateQueries(account: account) {
      query[kSecMatchLimit as String] = kSecMatchLimitOne
      query[kSecReturnData as String] = true
      var item: CFTypeRef?
      let status = SecItemCopyMatching(query as CFDictionary, &item)
      if status == errSecSuccess { return item as? Data }
      if status == errSecItemNotFound { return nil }
      lastStatus = status
      if status != missingEntitlementStatus { break }
    }
    throw NexusError.secureStore(lastStatus)
  }

  static func delete(account: String) throws {
    var lastStatus: OSStatus = errSecSuccess
    for query in candidateQueries(account: account) {
      let status = SecItemDelete(query as CFDictionary)
      if status == errSecSuccess || status == errSecItemNotFound { return }
      lastStatus = status
      if status != missingEntitlementStatus { break }
    }
    throw NexusError.secureStore(lastStatus)
  }

  private static func candidateQueries(account: String) -> [[String: Any]] {
    let scoped = baseQuery(account: account, includeAccessGroup: true)
    let unscoped = baseQuery(account: account, includeAccessGroup: false)
    return scoped.keys.count == unscoped.keys.count ? [unscoped] : [scoped, unscoped]
  }

  private static func baseQuery(account: String, includeAccessGroup: Bool) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ]
    if includeAccessGroup, let accessGroup = NexusEnvironment.keychainAccessGroup {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    return query
  }
}

struct NexusCachedCredential: Codable, Identifiable, Hashable {
  let id: String
  let service: String
  let username: String
  let password: String
  let website: String

  var host: String { NexusHost.normalize(website) }
}

enum NexusCredentialCache {
  static func save(_ credentials: [NexusCachedCredential]) throws {
    let data = try JSONEncoder().encode(credentials)
    try NexusSecureStore.save(data, account: NexusSecureStore.credentialCacheAccount)
  }

  static func load() throws -> [NexusCachedCredential] {
    guard let data = try NexusSecureStore.read(account: NexusSecureStore.credentialCacheAccount) else {
      return []
    }
    return try JSONDecoder().decode([NexusCachedCredential].self, from: data)
  }

  static func credentials(from passwords: [NexusPassword]) -> [NexusCachedCredential] {
    passwords.compactMap { row in
      guard row.kinds?.contains("PASSWORD") == true else { return nil }
      let password = String(row.rawSecret ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
      guard !password.isEmpty else { return nil }
      return NexusCachedCredential(
        id: row.id,
        service: clean(row.service),
        username: clean(row.username),
        password: password,
        website: clean(row.website)
      )
    }
  }

  static func matches(for serviceIdentifiers: [ASCredentialServiceIdentifier]) throws -> [NexusCachedCredential] {
    let requestedHosts = serviceIdentifiers.map { NexusHost.normalize($0.identifier) }.filter { !$0.isEmpty }
    guard !requestedHosts.isEmpty else { return try load() }
    return try load().filter { credential in
      let host = credential.host
      return requestedHosts.contains { requested in
        host == requested || host.hasSuffix(".\(requested)") || requested.hasSuffix(".\(host)")
      }
    }
  }
}

enum NexusCredentialIdentityBridge {
  static func sync(_ credentials: [NexusCachedCredential]) async {
    let identities: [any ASCredentialIdentity] = credentials.compactMap { credential -> ASPasswordCredentialIdentity? in
      guard !credential.host.isEmpty else { return nil }
      let service = ASCredentialServiceIdentifier(identifier: credential.host, type: .domain)
      return ASPasswordCredentialIdentity(
        serviceIdentifier: service,
        user: credential.username,
        recordIdentifier: credential.id
      )
    }
    try? await ASCredentialIdentityStore.shared.replaceCredentialIdentities(identities)
  }
}

@MainActor
final class NexusVaultModel: ObservableObject {
  @Published var selectedSection: NexusSection = .passwords
  @Published var snapshot = NexusVaultSnapshot()
  @Published var email = ""
  @Published var password = ""
  @Published var accountEmail = ""
  @Published var isAuthenticated = false
  @Published var isLoading = false
  @Published var errorMessage = ""

  private let client = NexusAPIClient()

  func bootstrap() {
    #if DEBUG
    if NexusEnvironment.usesMockVault {
      isAuthenticated = true
      accountEmail = "mock@nexus.local"
      snapshot = .mock
      return
    }
    #endif
    Task {
      await loadSession()
    }
  }

  func open(_ section: NexusSection) {
    selectedSection = section
  }

  func loadSession() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let session = try await client.session()
      isAuthenticated = session.authenticated
      accountEmail = session.email
      if session.authenticated {
        try await refresh()
      }
    } catch {
      isAuthenticated = false
      errorMessage = error.localizedDescription
    }
  }

  func login() {
    Task {
      await authenticate(mode: .login)
    }
  }

  func createAccount() {
    Task {
      await authenticate(mode: .create)
    }
  }

  func refreshAction() {
    Task {
      try? await refresh()
    }
  }

  func logout() {
    Task {
      do {
        try await client.logout()
        snapshot = NexusVaultSnapshot()
        isAuthenticated = false
        accountEmail = ""
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  private func authenticate(mode: NexusAuthMode) async {
    isLoading = true
    defer { isLoading = false }
    do {
      let session = switch mode {
      case .login:
        try await client.login(email: email, password: password)
      case .create:
        try await client.register(email: email, password: password)
      }
      guard session.authenticated else {
        throw NexusError.requestFailed("Authentication failed.")
      }
      accountEmail = session.email
      isAuthenticated = session.authenticated
      password = ""
      do {
        try await refresh()
      } catch {
        errorMessage = error.localizedDescription
      }
    } catch {
      isAuthenticated = false
      errorMessage = error.localizedDescription
    }
  }

  private func refresh() async throws {
    let nextSnapshot = try await client.vault()
    snapshot = nextSnapshot
    let credentials = NexusCredentialCache.credentials(from: nextSnapshot.passwords)
    try? NexusCredentialCache.save(credentials)
    await NexusCredentialIdentityBridge.sync(credentials)
  }
}

private enum NexusAuthMode {
  case login
  case create
}

struct NexusRootView: View {
  @StateObject private var model = NexusVaultModel()

  var body: some View {
    Group {
      if model.isAuthenticated {
        NexusVaultView()
          .environmentObject(model)
      } else {
        NexusLoginView()
          .environmentObject(model)
      }
    }
    .task {
      model.bootstrap()
      if let section = NexusRouteStore.consumePendingSection() {
        model.open(section)
      }
    }
    .onOpenURL { url in
      if let section = NexusRouteStore.section(from: url) {
        model.open(section)
      }
    }
  }
}

struct NexusLoginView: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    GeometryReader { proxy in
      let contentWidth = max(0, proxy.size.width - (NexusTokens.gutter * 2))
      let fieldWidth = min(contentWidth, NexusTokens.loggedOutFieldWidth)
      let brandSize = min(
        NexusTokens.loggedOutBrandMax,
        max(NexusTokens.loggedOutBrandMin, proxy.size.width * NexusTokens.loggedOutBrandScale)
      )
      VStack(spacing: NexusTokens.gutter) {
        NexusWordmark(size: brandSize)
        VStack(spacing: NexusTokens.gutter) {
          NexusLoggedOutField("Username", text: $model.email, width: fieldWidth)
          NexusLoggedOutSecureField("Password", text: $model.password, width: fieldWidth)
        }
        HStack(spacing: NexusTokens.loggedOutActionGap) {
          NexusButton("SIGN IN", variant: .primary, width: NexusTokens.loggedOutSignInWidth) { model.login() }
          NexusButton("CREATE", variant: .secondary, width: NexusTokens.loggedOutCreateWidth) { model.createAccount() }
        }
        if !model.errorMessage.isEmpty {
          Text(model.errorMessage)
            .font(NexusTokens.inputFont)
            .foregroundStyle(NexusTokens.muted)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(NexusTokens.gutter)
      .offset(y: NexusTokens.loggedOutContentOffsetY)
    }
    .background(NexusBlueprintBackground())
  }
}

struct NexusWordmark: View {
  let size: CGFloat

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: size * NexusTokens.loggedOutBrandTracking) {
      ForEach(Array("Nexus").map(String.init), id: \.self) { character in
        Text(character)
          .font(.system(size: size, weight: .semibold, design: .default))
          .fixedSize(horizontal: true, vertical: false)
      }
    }
    .padding(.horizontal, abs(size * NexusTokens.loggedOutBrandTracking) * 2)
    .fixedSize(horizontal: true, vertical: false)
  }
}

struct NexusVaultView: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    GeometryReader { proxy in
      if proxy.size.width <= 960 {
        VStack(spacing: 0) {
          NexusMobileTopBar()
          NexusMobileNav()
          NexusMobileNavSupplement()
          NexusSectionView(section: model.selectedSection, compact: true)
            .environmentObject(model)
        }
      } else {
        HStack(spacing: 0) {
          NexusSidebar()
          NexusSectionView(section: model.selectedSection, compact: false)
            .environmentObject(model)
        }
      }
    }
    .background(NexusBlueprintBackground())
  }
}

struct NexusSectionView: View {
  @EnvironmentObject private var model: NexusVaultModel
  let section: NexusSection
  let compact: Bool

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      pageContent
        .padding(.top, topPadding)
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, bottomPadding)
    }
    .background(Color.clear)
  }

  @ViewBuilder
  private var pageContent: some View {
    switch section {
    case .passwords:
      NexusPasswordsPage(snapshot: model.snapshot, compact: compact)
    case .apiKeys:
      NexusAPIKeysPage(snapshot: model.snapshot)
    case .cards:
      NexusCardsPage(snapshot: model.snapshot, compact: compact)
    case .subscriptions:
      NexusRecurringsPage(snapshot: model.snapshot, compact: compact)
    }
  }

  private var topPadding: CGFloat {
    guard !compact else { return NexusTokens.pageMobileTopPadding }
    switch section {
    case .passwords, .subscriptions:
      return NexusTokens.passwordsDesktopTopPadding
    case .apiKeys:
      return NexusTokens.apiKeysDesktopTopPadding
    case .cards:
      return NexusTokens.defaultDesktopTopPadding
    }
  }

  private var horizontalPadding: CGFloat {
    return compact ? NexusTokens.pageMobileHorizontalPadding : NexusTokens.pageDesktopHorizontalPadding
  }

  private var bottomPadding: CGFloat {
    compact ? NexusTokens.pageMobileBottomPadding : NexusTokens.pageDesktopBottomPadding
  }
}

private enum NexusTableColumns {
  static let passwords = [
    NexusTableColumn("service", "Service", weight: 17.864078),
    NexusTableColumn("username", "Username", weight: 16.504854),
    NexusTableColumn("type", "Type", weight: 14.563107),
    NexusTableColumn("password", "Password", weight: 14.563107),
    NexusTableColumn("website", "Website", weight: 17.11165),
    NexusTableColumn("note", "Note", weight: 17.451456),
    NexusTableColumn("actions", "", weight: 1.941748, alignment: .trailing)
  ]

  static let apiKeys = [
    NexusTableColumn("name", "Name", weight: 30),
    NexusTableColumn("value", "Value", weight: 42),
    NexusTableColumn("note", "Note", weight: 26),
    NexusTableColumn("actions", "", weight: 2, alignment: .trailing)
  ]

  static let cards = [
    NexusTableColumn("name", "Card Name", weight: 17.5),
    NexusTableColumn("network", "Type", weight: 10),
    NexusTableColumn("number", "Card Number", weight: 17.5),
    NexusTableColumn("credit", "Credit", weight: 12.5),
    NexusTableColumn("expiry", "Expiry", weight: 10),
    NexusTableColumn("cvv", "CVV", weight: 7.5),
    NexusTableColumn("nextBilling", "Next Billing", weight: 10),
    NexusTableColumn("note", "Note", weight: 13),
    NexusTableColumn("actions", "", weight: 2, alignment: .trailing)
  ]

  static let subscriptions = [
    NexusTableColumn("service", "Service", weight: 22.7136),
    NexusTableColumn("tier", "Tier", weight: 12.177024),
    NexusTableColumn("cadence", "Cadence", weight: 12.177024),
    NexusTableColumn("amount", "Amount", weight: 12.177024),
    NexusTableColumn("nextBilling", "Next Billing", weight: 10.047024),
    NexusTableColumn("status", "Status", weight: 12.177024),
    NexusTableColumn("note", "Note", weight: 16.53168),
    NexusTableColumn("actions", "", weight: 2, alignment: .trailing)
  ]
}

struct NexusPasswordsPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: NexusTokens.pageSectionGap) {
      NexusPasswordsMetricStrip(metrics: snapshot.passwordMetrics, compact: compact)
      NexusTableShell(
        columns: NexusTableColumns.passwords,
        minWidth: NexusTokens.passwordsTableMinWidth,
        variant: .passwords,
        rowCount: snapshot.passwords.count
      ) {
        ForEach(snapshot.sortedPasswords) { row in
          NexusPasswordTableRow(row: row)
        }
      }
    }
  }
}

struct NexusAPIKeysPage: View {
  let snapshot: NexusVaultSnapshot

  var body: some View {
    VStack(alignment: .leading, spacing: NexusTokens.pageSectionGap) {
      NexusTableShell(
        columns: NexusTableColumns.apiKeys,
        minWidth: NexusTokens.apiKeysTableMinWidth,
        variant: .apiKeys,
        rowCount: snapshot.apiKeys.count
      ) {
        ForEach(snapshot.sortedAPIKeys) { row in
          NexusAPIKeyTableRow(row: row)
        }
      }
    }
  }
}

struct NexusCardsPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: NexusTokens.pageSectionGap) {
      HStack {
        Spacer(minLength: 0)
        NexusMetricStrip(metrics: snapshot.cardMetrics, compact: compact)
      }
      NexusTableShell(
        columns: NexusTableColumns.cards,
        minWidth: NexusTokens.cardsTableMinWidth,
        variant: .cards,
        rowCount: snapshot.sortedCards.count
      ) {
        ForEach(snapshot.sortedCards) { row in
          NexusCardTableRow(row: row)
        }
      }
    }
  }
}

struct NexusRecurringsPage: View {
  let snapshot: NexusVaultSnapshot
  let compact: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 36) {
      NexusMetricStrip(metrics: snapshot.subscriptionMetrics, compact: compact, subscriptions: true)
      NexusSubscriptionsBoard(rows: snapshot.sortedSubscriptions)
    }
  }
}

struct NexusSidebar: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    VStack(alignment: .leading, spacing: NexusTokens.gutter) {
      Text("Nexus")
        .font(.system(size: 36, weight: .semibold, design: .default))
        .tracking(-2)
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .center)
      VStack(spacing: 8) {
        ForEach(NexusSection.allCases) { section in
          NexusNavButton(section: section, selected: model.selectedSection == section) {
            model.open(section)
          }
        }
      }
      Spacer()
      Text(model.accountEmail)
        .font(NexusTokens.inputFont)
        .foregroundStyle(NexusTokens.muted)
      NexusButton("Logout") { model.logout() }
    }
    .padding(18)
    .frame(width: NexusTokens.sidebarWidth)
    .background(NexusTokens.section)
  }
}

struct NexusMobileTopBar: View {
  @EnvironmentObject private var model: NexusVaultModel
  var horizontalPadding = NexusTokens.topBarHorizontalPadding
  var showAccount = true

  var body: some View {
    HStack(alignment: .center, spacing: NexusTokens.toolbarRowGap) {
      NexusSearchLine()
      HStack(spacing: NexusTokens.toolbarActionGap) {
        NexusSquareButton(systemName: "plus", variant: .primary) {}
        if showAccount {
          NexusSquareButton(iconPath: "/shared/icons/setting.png", variant: .settings) {}
        }
      }
    }
    .padding(.horizontal, horizontalPadding)
    .padding(.vertical, NexusTokens.topBarVerticalPadding)
  }
}

struct NexusMobileNav: View {
  @EnvironmentObject private var model: NexusVaultModel

  var body: some View {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NexusTokens.mobileNavGap) {
      ForEach(NexusSection.allCases) { section in
        NexusNavButton(section: section, selected: model.selectedSection == section) {
          model.open(section)
        }
      }
    }
    .padding(.horizontal, NexusTokens.topBarHorizontalPadding)
    .padding(.bottom, NexusTokens.mobileNavBottomPadding)
  }
}

struct NexusMobileNavSupplement: View {
  @EnvironmentObject private var model: NexusVaultModel
  var horizontalPadding = NexusTokens.topBarHorizontalPadding

  var body: some View {
    if model.selectedSection == .apiKeys {
      HStack {
        if let metric = model.snapshot.apiKeyMetrics.first(where: { $0.label == "LIVE KEYS" }) {
          NexusToolbarMetric(metric: metric)
        }
        Spacer(minLength: 0)
      }
      .padding(.horizontal, horizontalPadding)
      .padding(.bottom, NexusTokens.mobileNavBottomPadding)
    }
  }
}

struct NexusSearchLine: View {
  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: "magnifyingglass")
        .font(.system(size: 13, weight: .regular))
        .foregroundStyle(NexusTokens.muted)
      Text("")
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, NexusTokens.loggedOutFieldPadding)
    .frame(height: NexusTokens.control)
    .background(Color.white.opacity(0.84))
    .overlay(Rectangle().stroke(Color.black.opacity(0.14), lineWidth: 1))
  }
}

enum NexusTableVariant {
  case passwords
  case apiKeys
  case cards
  case subscriptions

  var headerBackground: Color {
    switch self {
    case .passwords:
      return NexusTokens.tableHeaderPassword
    case .cards:
      return .clear
    default:
      return NexusTokens.tableHeader
    }
  }

  var slabBackground: Color {
    switch self {
    case .passwords:
      return NexusTokens.passwordPanel
    case .apiKeys:
      return Color.white
    case .cards:
      return .clear
    case .subscriptions:
      return .clear
    }
  }

  var rowBackground: Color {
    switch self {
    case .cards:
      return NexusTokens.cardPanel
    case .subscriptions:
      return Color.white.opacity(0.84)
    case .passwords:
      return NexusTokens.passwordPanel
    case .apiKeys:
      return NexusTokens.panel
    }
  }
}

struct NexusToolbarMetric: View {
  let metric: NexusMetricItem

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 10) {
        Rectangle()
          .fill(NexusTokens.strong)
          .frame(width: NexusTokens.markerSize, height: NexusTokens.markerSize)
        Text(metric.label)
          .font(NexusTokens.popupMetricTagFont)
          .tracking(2.2)
          .foregroundStyle(NexusTokens.muted)
      }
      Text(metric.value)
        .font(NexusTokens.popupMetricValueFont)
        .tracking(-1.9)
        .lineSpacing(0)
        .foregroundStyle(NexusTokens.strong)
    }
    .accessibilityElement(children: .combine)
  }
}

struct NexusPasswordsMetricStrip: View {
  let metrics: [NexusMetricItem]
  let compact: Bool

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top, spacing: compact ? NexusTokens.metricCompactGap : 52) {
        ForEach(metrics) { metric in
          VStack(alignment: .leading, spacing: 10) {
            Rectangle()
              .fill(NexusTokens.strong)
              .frame(width: NexusTokens.markerSize, height: NexusTokens.markerSize)
            Text(metric.label)
              .font(NexusTokens.metricLabelFont)
              .tracking(2.2)
              .foregroundStyle(NexusTokens.muted)
            Text(metric.value)
              .font(compact ? NexusTokens.metricCompactValueFont : NexusTokens.metricValueFont)
              .tracking(-3.2)
              .lineLimit(1)
              .foregroundStyle(NexusTokens.strong)
          }
          .fixedSize(horizontal: true, vertical: false)
          .accessibilityElement(children: .combine)
        }
      }
      .padding(.bottom, 4)
    }
  }
}

struct NexusMetricStrip: View {
  let metrics: [NexusMetricItem]
  let compact: Bool
  var subscriptions = false

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top, spacing: spacing) {
        ForEach(metrics) { metric in
          VStack(alignment: .leading, spacing: subscriptions ? 10 : 8) {
            Text(metric.label)
              .font(NexusTokens.metricLabelFont)
              .tracking(2.2)
              .foregroundStyle(NexusTokens.muted)
            Text(metric.value)
              .font(compact ? NexusTokens.metricCompactValueFont : NexusTokens.metricValueFont)
              .tracking(-2.5)
              .lineSpacing(0)
              .foregroundStyle(NexusTokens.strong)
          }
          .padding(.leading, subscriptions ? NexusTokens.subscriptionsMetricInset : NexusTokens.metricInset)
          .overlay(alignment: .leading) {
            Rectangle()
              .fill(NexusTokens.strong)
              .frame(width: NexusTokens.metricBorderWidth)
          }
          .fixedSize(horizontal: true, vertical: false)
          .accessibilityElement(children: .combine)
        }
      }
      .padding(.bottom, 4)
    }
  }

  private var spacing: CGFloat {
    if compact { return NexusTokens.metricCompactGap }
    return subscriptions ? NexusTokens.subscriptionsMetricGap : NexusTokens.metricHorizontalGap
  }
}

struct NexusTableShell<Content: View>: View {
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let variant: NexusTableVariant
  let rowCount: Int
  @ViewBuilder let content: () -> Content

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack(spacing: 0) {
        NexusTableHeaderRow(columns: columns, minWidth: minWidth, variant: variant)
        if rowCount > 0 {
          content()
        } else {
          NexusEmptyTableRow(columns: columns, minWidth: minWidth, label: "NO MATCHES")
        }
      }
      .frame(minWidth: minWidth, alignment: .leading)
      .background(variant.slabBackground)
      .overlay {
        if variant == .apiKeys {
          Rectangle().stroke(NexusTokens.outlineSoft, lineWidth: 1)
        }
      }
    }
  }
}

struct NexusTableHeaderRow: View {
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let variant: NexusTableVariant

  var body: some View {
    HStack(spacing: 0) {
      ForEach(columns) { column in
        NexusHeaderCell(column: column, columns: columns, minWidth: minWidth, variant: variant)
      }
    }
  }
}

struct NexusHeaderCell: View {
  let column: NexusTableColumn
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let variant: NexusTableVariant

  var body: some View {
    Text(column.label)
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .textCase(.uppercase)
      .foregroundStyle(NexusTokens.muted)
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: column.alignment)
      .padding(.horizontal, NexusTokens.tableCellHorizontalPadding)
      .padding(.vertical, NexusTokens.tableHeaderVerticalPadding)
      .frame(width: cellWidth(column, columns: columns, minWidth: minWidth), alignment: column.alignment)
      .background(variant.headerBackground)
  }
}

struct NexusTableCell<Content: View>: View {
  let column: NexusTableColumn
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let alignment: Alignment
  let verticalPadding: CGFloat
  @ViewBuilder let content: () -> Content

  init(
    column: NexusTableColumn,
    columns: [NexusTableColumn],
    minWidth: CGFloat,
    alignment: Alignment? = nil,
    verticalPadding: CGFloat = NexusTokens.tableCellVerticalPadding,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.column = column
    self.columns = columns
    self.minWidth = minWidth
    self.alignment = alignment ?? column.alignment
    self.verticalPadding = verticalPadding
    self.content = content
  }

  var body: some View {
    content()
      .frame(maxWidth: .infinity, alignment: alignment)
      .padding(.horizontal, NexusTokens.tableCellHorizontalPadding)
      .padding(.vertical, verticalPadding)
      .frame(width: cellWidth(column, columns: columns, minWidth: minWidth), alignment: alignment)
  }
}

struct NexusEmptyTableRow: View {
  let columns: [NexusTableColumn]
  let minWidth: CGFloat
  let label: String

  var body: some View {
    Text(label)
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .foregroundStyle(NexusTokens.muted)
      .frame(width: minWidth)
      .frame(minHeight: 68)
      .background(NexusTokens.panel)
  }
}

struct NexusPasswordTableRow: View {
  let row: NexusPassword
  private let columns = NexusTableColumns.passwords
  private let minWidth = NexusTokens.passwordsTableMinWidth

  var body: some View {
    NexusBodyRow(variant: .passwords) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth) {
        NexusPrimaryCell(
          title: clean(row.service),
          iconURL: row.resolvedIconUrl,
          iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
          website: row.website,
          fallback: monogram(row.service, row.website, row.username, fallback: "S")
        )
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.username))
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth) {
        NexusKindChipGroup(kinds: row.kinds ?? [])
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth) {
        NexusMaskedCell(clean(row.passwordMask))
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(NexusHost.normalize(row.website).isEmpty ? clean(row.website) : NexusHost.normalize(row.website))
      }
      NexusTableCell(column: columns[5], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[6], columns: columns, minWidth: minWidth, alignment: .trailing) {
        NexusRowAction()
      }
    }
  }
}

struct NexusAPIKeyTableRow: View {
  let row: NexusAPIKey
  private let columns = NexusTableColumns.apiKeys
  private let minWidth = NexusTokens.apiKeysTableMinWidth

  var body: some View {
    NexusBodyRow(variant: .apiKeys) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth) {
        Text(clean(row.keyName))
          .font(NexusTokens.tablePrimaryFont)
          .foregroundStyle(NexusTokens.strong)
          .lineLimit(1)
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth) {
        NexusBoxedCell(clean(row.maskedValue ?? row.rawValue))
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth, alignment: .trailing) {
        NexusRowAction()
      }
    }
  }
}

struct NexusCardTableRow: View {
  let row: NexusCard
  private let columns = NexusTableColumns.cards
  private let minWidth = NexusTokens.cardsTableMinWidth

  var body: some View {
    NexusBodyRow(variant: .cards) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth) {
        NexusPrimaryCell(
          title: clean(row.cardName),
          iconURL: row.resolvedIconUrl,
          iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
          website: nil,
          fallback: monogram(row.cardName, row.network, fallback: "C")
        )
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth) {
        NexusChip(label: clean(row.network), style: isNoCreditNetwork(row.network) || clean(row.network).uppercased() == "AMEX" ? .ghost : .normal)
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.maskedNumber ?? row.rawCardNumber))
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth) {
        NexusValueCell(cardCredit(row))
          .foregroundStyle(isNoCreditNetwork(row.network) ? Color.black.opacity(0.35) : NexusTokens.strong)
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.expiry))
      }
      NexusTableCell(column: columns[5], columns: columns, minWidth: minWidth) {
        NexusMaskedCell(clean(row.cvvMask ?? row.rawCvv))
      }
      NexusTableCell(column: columns[6], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(nextCardBillingDate(row).map(NexusDate.formatShort) ?? "-")
      }
      NexusTableCell(column: columns[7], columns: columns, minWidth: minWidth) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[8], columns: columns, minWidth: minWidth, alignment: .trailing) {
        NexusRowAction()
      }
    }
  }
}

struct NexusSubscriptionsBoard: View {
  let rows: [NexusRecurring]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack(spacing: NexusTokens.subscriptionsBoardGap) {
        if rows.isEmpty {
          NexusEmptySubscriptionRow()
        } else {
          ForEach(rows) { row in
            NexusSubscriptionBoardRow(row: row)
          }
        }
      }
      .frame(minWidth: NexusTokens.subscriptionsBoardMinWidth, alignment: .leading)
      .padding(.bottom, 4)
    }
    .accessibilityLabel("Subscriptions")
  }
}

struct NexusSubscriptionBoardRow: View {
  let row: NexusRecurring
  private let columns = NexusTableColumns.subscriptions
  private let minWidth = NexusTokens.subscriptionsBoardMinWidth

  var body: some View {
    HStack(spacing: NexusTokens.subscriptionsRowGap) {
      NexusTableCell(column: columns[0], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusPrimaryCell(
          title: clean(row.service),
          iconURL: row.resolvedIconUrl,
          iconKey: firstNonEmpty(row.resolvedIconKey, row.iconKey),
          website: nil,
          fallback: monogram(row.service, row.tier, fallback: "R")
        )
      }
      NexusTableCell(column: columns[1], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusChip(label: clean(row.tier), style: clean(row.tier).uppercased() == "FREE TRIAL" ? .ghost : .normal)
      }
      NexusTableCell(column: columns[2], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusChip(label: clean(row.cadence), style: .normal)
      }
      NexusTableCell(column: columns[3], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusValueCell(recurringAmount(row))
      }
      NexusTableCell(column: columns[4], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusSecondaryCell(nextSubscriptionBillingDate(row).map(NexusDate.formatShort) ?? "-")
      }
      NexusTableCell(column: columns[5], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusChip(label: clean(row.status), style: clean(row.status).uppercased() == "ACTIVE" ? .success : .muted)
      }
      NexusTableCell(column: columns[6], columns: columns, minWidth: minWidth, verticalPadding: 0) {
        NexusSecondaryCell(clean(row.note))
      }
      NexusTableCell(column: columns[7], columns: columns, minWidth: minWidth, alignment: .trailing, verticalPadding: 0) {
        NexusRowAction()
      }
    }
    .padding(.horizontal, NexusTokens.subscriptionsRowHorizontalPadding)
    .padding(.vertical, NexusTokens.subscriptionsRowVerticalPadding)
    .frame(minHeight: NexusTokens.tableRowMinHeight)
    .background(Color.white.opacity(0.84))
  }
}

struct NexusEmptySubscriptionRow: View {
  var body: some View {
    Text("NO MATCHES")
      .font(NexusTokens.tableHeaderFont)
      .tracking(2)
      .foregroundStyle(NexusTokens.muted)
      .frame(minWidth: NexusTokens.subscriptionsBoardMinWidth, minHeight: 90)
      .background(Color.white.opacity(0.84))
  }
}

struct NexusBodyRow<Content: View>: View {
  let variant: NexusTableVariant
  @ViewBuilder let content: () -> Content

  var body: some View {
    HStack(spacing: 0) {
      content()
    }
    .frame(minHeight: NexusTokens.tableRowMinHeight)
    .background(variant.rowBackground)
    .overlay(alignment: .top) {
      Rectangle()
        .fill(variant == .cards ? NexusTokens.outlineSoft : NexusTokens.softBorder)
        .frame(height: 1)
    }
  }
}

struct NexusPrimaryCell: View {
  let title: String
  let iconURL: String?
  let iconKey: String?
  let website: String?
  let fallback: String

  var body: some View {
    HStack(spacing: NexusTokens.tableCellGap) {
      NexusIconTile(urlString: iconURL, iconKey: iconKey, website: website, fallback: fallback)
      Text(title)
        .font(NexusTokens.tablePrimaryFont)
        .tracking(-0.45)
        .foregroundStyle(NexusTokens.strong)
        .lineLimit(1)
    }
  }
}

struct NexusIconTile: View {
  let urlString: String?
  let iconKey: String?
  let website: String?
  let fallback: String

  var body: some View {
    ZStack {
      if let url = resolvedIconURL(urlString, iconKey: iconKey, website: website, fallback: fallback) {
        fallbackView
        NexusIconWebImage(url: url)
      } else {
        fallbackView
      }
    }
    .frame(width: NexusTokens.tableIconSize, height: NexusTokens.tableIconSize)
    .clipped()
  }

  private var fallbackView: some View {
    Text(fallback)
      .font(.system(size: 15, weight: .semibold, design: .default))
      .foregroundStyle(NexusTokens.strong)
      .textCase(.uppercase)
  }
}

#if os(iOS)
struct NexusIconWebImage: UIViewRepresentable {
  let url: URL

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView(frame: .zero)
    webView.isOpaque = false
    webView.backgroundColor = .clear
    webView.scrollView.backgroundColor = .clear
    webView.scrollView.isScrollEnabled = false
    webView.isUserInteractionEnabled = false
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    webView.loadHTMLString(iconHTML(for: url), baseURL: nil)
  }
}
#elseif os(macOS)
struct NexusIconWebImage: NSViewRepresentable {
  let url: URL

  func makeNSView(context: Context) -> WKWebView {
    let webView = WKWebView(frame: .zero)
    webView.setValue(false, forKey: "drawsBackground")
    return webView
  }

  func updateNSView(_ webView: WKWebView, context: Context) {
    webView.loadHTMLString(iconHTML(for: url), baseURL: nil)
  }
}
#endif

private func iconHTML(for url: URL) -> String {
  """
  <!doctype html>
  <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <style>
        html, body {
          width: 100%;
          height: 100%;
          margin: 0;
          overflow: hidden;
          background: transparent;
        }
        img {
          display: block;
          width: 100%;
          height: 100%;
          object-fit: contain;
        }
      </style>
    </head>
    <body>
      <img alt="" src="\(htmlAttributeEscaped(url.absoluteString))" />
    </body>
  </html>
  """
}

private func htmlAttributeEscaped(_ value: String) -> String {
  value
    .replacingOccurrences(of: "&", with: "&amp;")
    .replacingOccurrences(of: "\"", with: "&quot;")
    .replacingOccurrences(of: "<", with: "&lt;")
    .replacingOccurrences(of: ">", with: "&gt;")
}

struct NexusKindChipGroup: View {
  let kinds: [String]

  var body: some View {
    HStack(spacing: 4) {
      if kinds.isEmpty {
        NexusSecondaryCell("-")
      } else {
        ForEach(kinds, id: \.self) { kind in
          let normalized = clean(kind).uppercased()
          NexusChip(
            label: normalized == "OTP" ? "ONE-TIME-CODE" : normalized,
            style: normalized == "OTP" ? .muted : .normal
          )
        }
      }
    }
  }
}

enum NexusChipStyle {
  case normal
  case muted
  case ghost
  case success
}

struct NexusChip: View {
  let label: String
  let style: NexusChipStyle

  var body: some View {
    Text(label)
      .font(NexusTokens.chipFont)
      .tracking(0.9)
      .lineLimit(1)
      .padding(.horizontal, 8)
      .frame(minHeight: 22)
      .foregroundStyle(foreground)
      .background(background)
  }

  private var foreground: Color {
    switch style {
    case .success:
      return Color(red: 0.176, green: 0.373, blue: 0.11)
    case .muted, .ghost:
      return NexusTokens.muted
    case .normal:
      return NexusTokens.strong
    }
  }

  private var background: Color {
    switch style {
    case .success:
      return Color(red: 0.42, green: 0.67, blue: 0.31).opacity(0.12)
    case .ghost:
      return Color.clear
    case .muted:
      return NexusTokens.mutedPanel.opacity(0.7)
    case .normal:
      return NexusTokens.mutedPanel
    }
  }
}

struct NexusSecondaryCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tableSecondaryFont)
      .tracking(0.28)
      .foregroundStyle(NexusTokens.muted)
      .lineLimit(1)
  }
}

struct NexusValueCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tablePrimaryFont)
      .foregroundStyle(NexusTokens.strong)
      .lineLimit(1)
  }
}

struct NexusMaskedCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tablePrimaryFont)
      .tracking(1.8)
      .foregroundStyle(NexusTokens.strong)
      .lineLimit(1)
  }
}

struct NexusBoxedCell: View {
  let value: String

  init(_ value: String) {
    self.value = value
  }

  var body: some View {
    Text(value)
      .font(NexusTokens.tableMonoFont)
      .tracking(0.25)
      .foregroundStyle(NexusTokens.muted)
      .lineLimit(1)
      .padding(.horizontal, NexusTokens.boxedCellHorizontalPadding)
      .frame(height: NexusTokens.boxedCellHeight)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(NexusTokens.mutedPanel)
  }
}

struct NexusRowAction: View {
  var body: some View {
    Image(systemName: "ellipsis")
      .font(.system(size: 16, weight: .regular))
      .foregroundStyle(NexusTokens.strong)
      .frame(width: NexusTokens.markerSize * 4, height: NexusTokens.markerSize * 4)
  }
}

private func cellWidth(_ column: NexusTableColumn, columns: [NexusTableColumn], minWidth: CGFloat) -> CGFloat {
  let total = columns.reduce(CGFloat.zero) { $0 + $1.weight }
  guard total > 0 else { return minWidth / CGFloat(max(columns.count, 1)) }
  return minWidth * column.weight / total
}

private func monogram(_ values: String?..., fallback: String) -> String {
  for value in values {
    let normalized = emptyToBlank(value)
    if let first = normalized.first {
      return String(first).uppercased()
    }
  }
  return fallback
}

private func resolvedIconURL(_ value: String?, iconKey: String?, website: String?, fallback: String) -> URL? {
  let raw = emptyToBlank(value)
  if !raw.isEmpty {
    if raw.hasPrefix("http://") || raw.hasPrefix("https://") {
      return URL(string: raw)
    }
    if raw.hasPrefix("/") {
      return nexusAPIURL(path: raw, fallback: fallback)
    }
    if raw.contains("/") {
      return nexusAPIURL(path: raw, fallback: fallback)
    }
    return nexusAPIURL(path: "/api/site-icons/\(percentEncodePathComponent(raw))", fallback: fallback)
  }
  let key = firstNonEmpty(iconKey, NexusHost.normalize(website))
  guard !key.isEmpty else { return nil }
  return nexusAPIURL(path: "/api/site-icons/\(percentEncodePathComponent(key))", fallback: fallback)
}

private func nexusAPIURL(path: String, fallback: String) -> URL? {
  var normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
  if normalizedPath.hasPrefix("/nexus/api/") {
    normalizedPath.removeFirst("/nexus".count)
  }
  var queryItems: [URLQueryItem] = []
  if !fallback.isEmpty {
    queryItems.append(URLQueryItem(name: "fallback", value: fallback))
  }
  var components = URLComponents(string: NexusEnvironment.baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + normalizedPath)
  components?.queryItems = queryItems.isEmpty ? nil : queryItems
  return components?.url
}

private func nexusAssetURL(path: String) -> URL? {
  var normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
  if normalizedPath.hasPrefix("/nexus/") {
    normalizedPath.removeFirst("/nexus".count)
  }
  return URL(string: NexusEnvironment.baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + normalizedPath)
}

private func percentEncodePathComponent(_ value: String) -> String {
  var allowed = CharacterSet.urlPathAllowed
  allowed.remove(charactersIn: "/?#[]@!$&'()*+,;=")
  return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
}

private func firstNonEmpty(_ values: String?...) -> String {
  for value in values {
    let normalized = emptyToBlank(value)
    if !normalized.isEmpty {
      return normalized
    }
  }
  return ""
}

private func cardCredit(_ card: NexusCard) -> String {
  guard !isNoCreditNetwork(card.network) else { return "-" }
  return NexusCurrency.format(card.creditLimit ?? 0, currency: card.creditCurrency ?? "USD", digits: 0)
}

private func recurringAmount(_ recurring: NexusRecurring) -> String {
  NexusCurrency.format(recurring.amount ?? 0, currency: recurring.amountCurrency ?? "USD", digits: 2)
}

struct NexusNavButton: View {
  let section: NexusSection
  let selected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: NexusTokens.navItemGap) {
        NexusAssetIcon(path: section.navIconPath, selected: selected, size: NexusTokens.navIconSize)
        Text(section.title)
          .font(.system(size: 12, weight: .bold, design: .default))
          .tracking(2.4)
          .lineLimit(1)
          .minimumScaleFactor(0.82)
        Spacer(minLength: 0)
      }
      .padding(.horizontal, 14)
      .frame(maxWidth: .infinity, alignment: .leading)
      .frame(height: NexusTokens.control)
    }
    .buttonStyle(.plain)
    .foregroundStyle(selected ? Color.white : NexusTokens.muted)
    .background(selected ? NexusTokens.strong : Color.clear)
    .clipShape(RoundedRectangle(cornerRadius: NexusTokens.corner))
  }
}

struct NexusAssetIcon: View {
  let path: String
  var selected = false
  let size: CGFloat

  var body: some View {
    Group {
      if let url = nexusAssetURL(path: path) {
        AsyncImage(url: url) { phase in
          if let image = phase.image {
            assetImage(image)
          } else {
            Color.clear
          }
        }
      } else {
        Color.clear
      }
    }
    .frame(width: size, height: size)
  }

  @ViewBuilder
  private func assetImage(_ image: Image) -> some View {
    let icon = image
      .resizable()
      .aspectRatio(contentMode: .fit)
    if selected {
      icon.colorInvert()
    } else {
      icon
    }
  }
}

struct NexusButton: View {
  enum Variant {
    case primary
    case secondary
  }

  let title: String
  let variant: Variant
  let width: CGFloat?
  let action: () -> Void

  init(_ title: String, variant: Variant = .secondary, width: CGFloat? = nil, action: @escaping () -> Void) {
    self.title = title
    self.variant = variant
    self.width = width
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 11.5, weight: .bold, design: .default))
        .tracking(2.2)
        .textCase(.uppercase)
        .frame(minHeight: NexusTokens.control)
        .padding(.horizontal, 16)
    }
    .buttonStyle(.plain)
    .frame(width: width)
    .foregroundStyle(variant == .primary ? Color.white : NexusTokens.strong)
    .background(variant == .primary ? NexusTokens.strong : Color.clear)
    .overlay(RoundedRectangle(cornerRadius: NexusTokens.corner).stroke(NexusTokens.strong, lineWidth: 1))
    .clipShape(RoundedRectangle(cornerRadius: NexusTokens.corner))
  }
}

struct NexusSquareButton: View {
  enum Variant {
    case primary
    case settings
  }

  var systemName: String?
  var iconPath: String?
  var variant: Variant
  let action: () -> Void

  init(systemName: String, variant: Variant = .settings, action: @escaping () -> Void) {
    self.systemName = systemName
    self.iconPath = nil
    self.variant = variant
    self.action = action
  }

  init(iconPath: String, variant: Variant = .settings, action: @escaping () -> Void) {
    self.systemName = nil
    self.iconPath = iconPath
    self.variant = variant
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      Group {
        if let iconPath {
          NexusAssetIcon(path: iconPath, selected: false, size: NexusTokens.buttonSymbolSize)
        } else if let systemName {
          Image(systemName: systemName)
            .font(.system(size: NexusTokens.buttonSymbolSize * 0.72, weight: .bold))
        }
      }
      .frame(width: NexusTokens.control, height: NexusTokens.control)
    }
    .buttonStyle(.plain)
    .foregroundStyle(variant == .primary ? Color.white : NexusTokens.strong)
    .background(variant == .primary ? NexusTokens.strong : Color.white.opacity(0.9))
    .overlay(Rectangle().stroke(variant == .primary ? NexusTokens.strong : NexusTokens.strong, lineWidth: 1))
  }
}

struct NexusInput: View {
  let title: String
  @Binding var text: String

  init(_ title: String, text: Binding<String>) {
    self.title = title
    self._text = text
  }

  var body: some View {
    TextField(title, text: $text)
      .textFieldStyle(.plain)
      .font(NexusTokens.inputFont)
      .padding(.horizontal, 14)
      .frame(width: 320, height: NexusTokens.control)
      .background(Color.white.opacity(0.86))
      .overlay(Rectangle().stroke(NexusTokens.border, lineWidth: 1))
  }
}

struct NexusSecureInput: View {
  let title: String
  @Binding var text: String

  init(_ title: String, text: Binding<String>) {
    self.title = title
    self._text = text
  }

  var body: some View {
    SecureField(title, text: $text)
      .textFieldStyle(.plain)
      .font(NexusTokens.inputFont)
      .padding(.horizontal, 14)
      .frame(width: 320, height: NexusTokens.control)
      .background(Color.white.opacity(0.86))
      .overlay(Rectangle().stroke(NexusTokens.border, lineWidth: 1))
  }
}

struct NexusLoggedOutField: View {
  let title: String
  @Binding var text: String
  let width: CGFloat

  init(_ title: String, text: Binding<String>, width: CGFloat) {
    self.title = title
    self._text = text
    self.width = width
  }

  var body: some View {
    labeledField {
      TextField("", text: $text)
        #if os(iOS)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .keyboardType(.emailAddress)
        #endif
    }
  }

  private func labeledField<Field: View>(@ViewBuilder field: () -> Field) -> some View {
    ZStack(alignment: .topLeading) {
      Text(title)
        .font(NexusTokens.labelFont)
        .tracking(2.2)
        .textCase(.uppercase)
        .foregroundStyle(NexusTokens.muted)
        .offset(y: -(NexusTokens.modalLabelOffset + 10))
      field()
        .textFieldStyle(.plain)
        .font(NexusTokens.inputFont)
        .padding(.horizontal, NexusTokens.loggedOutFieldPadding)
        .frame(width: width, height: NexusTokens.control)
        .background(Color.white.opacity(0.84))
        .overlay(Rectangle().stroke(Color.black.opacity(0.14), lineWidth: 1))
    }
    .frame(width: width, height: NexusTokens.control, alignment: .topLeading)
  }
}

struct NexusLoggedOutSecureField: View {
  let title: String
  @Binding var text: String
  let width: CGFloat

  init(_ title: String, text: Binding<String>, width: CGFloat) {
    self.title = title
    self._text = text
    self.width = width
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      Text(title)
        .font(NexusTokens.labelFont)
        .tracking(2.2)
        .textCase(.uppercase)
        .foregroundStyle(NexusTokens.muted)
        .offset(y: -(NexusTokens.modalLabelOffset + 10))
      SecureField("", text: $text)
        .textFieldStyle(.plain)
        .font(NexusTokens.inputFont)
        .padding(.horizontal, NexusTokens.loggedOutFieldPadding)
        .frame(width: width, height: NexusTokens.control)
        .background(Color.white.opacity(0.84))
        .overlay(Rectangle().stroke(Color.black.opacity(0.14), lineWidth: 1))
    }
    .frame(width: width, height: NexusTokens.control, alignment: .topLeading)
  }
}

struct NexusBlueprintBackground: View {
  var body: some View {
    Canvas { context, size in
      var path = Path()
      var x: CGFloat = 0
      while x <= size.width {
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: size.height))
        x += NexusTokens.grid
      }
      var y: CGFloat = 0
      while y <= size.height {
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: size.width, y: y))
        y += NexusTokens.grid
      }
      context.stroke(path, with: .color(Color(red: 0.906, green: 0.906, blue: 0.906)), lineWidth: 1)
    }
    .background(NexusTokens.base)
    .ignoresSafeArea()
  }
}

struct NexusAutoFillPickerView: View {
  let credentials: [NexusCachedCredential]
  let select: (NexusCachedCredential) -> Void

  var body: some View {
    VStack(spacing: NexusTokens.seam) {
      ForEach(credentials) { credential in
        Button {
          select(credential)
        } label: {
          HStack {
            VStack(alignment: .leading, spacing: 3) {
              Text(credential.service)
                .font(.system(size: 15, weight: .semibold, design: .default))
              Text(credential.username)
                .font(NexusTokens.inputFont)
                .foregroundStyle(NexusTokens.muted)
            }
            Spacer()
            Text(credential.host)
              .font(NexusTokens.inputFont)
              .foregroundStyle(NexusTokens.muted)
          }
          .padding(.horizontal, 14)
          .frame(minHeight: 54)
          .background(NexusTokens.panel)
          .overlay(Rectangle().stroke(NexusTokens.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
      }
    }
    .padding(NexusTokens.gutter)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(NexusTokens.base)
  }
}

enum NexusRouteStore {
  private static let pendingKey = "pending-section"

  static func savePendingSection(_ section: NexusSection) {
    defaults.set(section.rawValue, forKey: pendingKey)
  }

  static func consumePendingSection() -> NexusSection? {
    guard let raw = defaults.string(forKey: pendingKey), let section = NexusSection(rawValue: raw) else {
      return nil
    }
    defaults.removeObject(forKey: pendingKey)
    return section
  }

  static func section(from url: URL) -> NexusSection? {
    if url.scheme == "nexus", url.host == "section" {
      return NexusSection(rawValue: url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }
    return nil
  }

  private static var defaults: UserDefaults {
    if let appGroup = NexusEnvironment.appGroup, let groupDefaults = UserDefaults(suiteName: appGroup) {
      return groupDefaults
    }
    return .standard
  }
}
