import AppIntents
import Foundation

protocol NexusOpenSectionIntent: AppIntent {
  static var section: NexusSection { get }
}

extension NexusOpenSectionIntent {
  static var openAppWhenRun: Bool { true }

  func perform() async throws -> some IntentResult {
    Self.section.saveForLaunch()
    return .result()
  }
}

struct NexusOpenPasswordsIntent: NexusOpenSectionIntent {
  static let title: LocalizedStringResource = "Open Passwords"
  static let description = IntentDescription("Open Nexus passwords.")
  static let section: NexusSection = .passwords
}

struct NexusOpenAPIKeysIntent: NexusOpenSectionIntent {
  static let title: LocalizedStringResource = "Open API Keys"
  static let description = IntentDescription("Open Nexus API keys.")
  static let section: NexusSection = .apiKeys
}

struct NexusOpenCardsIntent: NexusOpenSectionIntent {
  static let title: LocalizedStringResource = "Open Cards"
  static let description = IntentDescription("Open Nexus cards.")
  static let section: NexusSection = .cards
}

struct NexusOpenRecurringsIntent: NexusOpenSectionIntent {
  static let title: LocalizedStringResource = "Open Recurrings"
  static let description = IntentDescription("Open Nexus recurrings.")
  static let section: NexusSection = .subscriptions
}

struct NexusAppShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: NexusOpenPasswordsIntent(),
      phrases: [
        "Open \(.applicationName) passwords",
        "Show passwords in \(.applicationName)"
      ],
      shortTitle: "Passwords",
      systemImageName: "lock"
    )
    AppShortcut(
      intent: NexusOpenAPIKeysIntent(),
      phrases: [
        "Open \(.applicationName) API keys",
        "Show API keys in \(.applicationName)"
      ],
      shortTitle: "API Keys",
      systemImageName: "key"
    )
    AppShortcut(
      intent: NexusOpenCardsIntent(),
      phrases: [
        "Open \(.applicationName) cards",
        "Show cards in \(.applicationName)"
      ],
      shortTitle: "Cards",
      systemImageName: "creditcard"
    )
    AppShortcut(
      intent: NexusOpenRecurringsIntent(),
      phrases: [
        "Open \(.applicationName) recurrings",
        "Show recurrings in \(.applicationName)"
      ],
      shortTitle: "Recurrings",
      systemImageName: "calendar"
    )
  }
}

private extension NexusSection {
  func saveForLaunch() {
    NexusRouteStore.savePendingSection(self)
  }
}
