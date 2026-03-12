//
//  SceneDelegate.swift
//  MarkEditiOS
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)
    window.backgroundColor = .systemBackground
    self.window = window
    window.makeKeyAndVisible()

    // Defer DocumentBrowserViewController init to the next run loop pass so the
    // window renders first — UIDocumentBrowserViewController performs heavy disk
    // work on first launch that would otherwise block the initial frame.
    DispatchQueue.main.async { [weak window] in
      window?.rootViewController = DocumentBrowserViewController()
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let context = URLContexts.first,
          let windowScene = scene as? UIWindowScene,
          let documentBrowser = windowScene.windows.first?.rootViewController as? DocumentBrowserViewController
    else { return }

    documentBrowser.revealDocument(at: context.url, importIfNeeded: true) { _, _ in }
  }
}
