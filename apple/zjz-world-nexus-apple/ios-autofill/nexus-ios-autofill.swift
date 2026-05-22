import AuthenticationServices
import SwiftUI
import UIKit

final class NexusIOSCredentialProviderViewController: ASCredentialProviderViewController {
  private var hostController: UIHostingController<NexusAutoFillPickerView>?

  override func prepareInterfaceForExtensionConfiguration() {
    show(credentials: (try? NexusCredentialCache.load()) ?? [])
  }

  override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    show(credentials: (try? NexusCredentialCache.matches(for: serviceIdentifiers)) ?? [])
  }

  override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
    guard let credential = credential(matching: credentialIdentity) else {
      cancel()
      return
    }
    complete(with: credential)
  }

  override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
    guard let credential = credential(matching: credentialIdentity) else {
      show(credentials: (try? NexusCredentialCache.load()) ?? [])
      return
    }
    show(credentials: [credential])
  }

  private func show(credentials: [NexusCachedCredential]) {
    let root = NexusAutoFillPickerView(credentials: credentials) { [weak self] credential in
      self?.complete(with: credential)
    }
    let next = UIHostingController(rootView: root)
    hostController?.willMove(toParent: nil)
    hostController?.view.removeFromSuperview()
    hostController?.removeFromParent()
    addChild(next)
    next.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(next.view)
    NSLayoutConstraint.activate([
      next.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      next.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      next.view.topAnchor.constraint(equalTo: view.topAnchor),
      next.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    next.didMove(toParent: self)
    hostController = next
  }

  private func credential(matching identity: ASPasswordCredentialIdentity) -> NexusCachedCredential? {
    guard let recordIdentifier = identity.recordIdentifier else { return nil }
    return try? NexusCredentialCache.load().first { $0.id == recordIdentifier }
  }

  private func complete(with credential: NexusCachedCredential) {
    let selected = ASPasswordCredential(user: credential.username, password: credential.password)
    extensionContext.completeRequest(withSelectedCredential: selected, completionHandler: nil)
  }

  private func cancel() {
    let error = NSError(domain: "one.zjz.nexus.autofill", code: 1)
    extensionContext.cancelRequest(withError: error)
  }
}
