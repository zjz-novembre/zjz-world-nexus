import SwiftUI

@main
struct NexusMacOSApp: App {
  var body: some Scene {
    WindowGroup {
      NexusRootView()
        .frame(minWidth: 980, minHeight: 620)
    }
    .commands {
      CommandGroup(replacing: .newItem) {}
    }
  }
}
