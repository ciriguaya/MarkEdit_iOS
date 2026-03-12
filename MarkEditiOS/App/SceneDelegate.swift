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

    NSLog("[MarkEditiOS] SceneDelegate scene(willConnectTo:) — creating window")

    let window = UIWindow(windowScene: windowScene)
    let documentBrowser = DocumentBrowserViewController()
    window.rootViewController = documentBrowser
    self.window = window
    window.makeKeyAndVisible()

    NSLog("[MarkEditiOS] SceneDelegate makeKeyAndVisible done, window.frame=%@", NSCoder.string(for: window.frame))
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let context = URLContexts.first,
          let windowScene = scene as? UIWindowScene,
          let documentBrowser = windowScene.windows.first?.rootViewController as? DocumentBrowserViewController
    else { return }

    documentBrowser.revealDocument(at: context.url, importIfNeeded: true) { _, _ in }
  }
}
