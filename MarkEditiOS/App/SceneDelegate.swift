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
    // NSLog BEFORE the guard so we know if this method is called at all
    NSLog("[MarkEditiOS] SceneDelegate scene(willConnectTo:) — scene type: %@", String(describing: type(of: scene)))

    guard let windowScene = scene as? UIWindowScene else {
      NSLog("[MarkEditiOS] SceneDelegate — guard FAILED: scene is not UIWindowScene, aborting")
      return
    }

    // Show window immediately with a red background + spinner.
    // If you see red in the simulator, SceneDelegate ran and makeKeyAndVisible succeeded.
    let window = UIWindow(windowScene: windowScene)
    window.backgroundColor = .systemRed

    let placeholder = UIViewController()
    placeholder.view.backgroundColor = .systemRed
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .white
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.startAnimating()
    placeholder.view.addSubview(spinner)
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: placeholder.view.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: placeholder.view.centerYAnchor),
    ])

    window.rootViewController = placeholder
    self.window = window
    window.makeKeyAndVisible()
    NSLog("[MarkEditiOS] SceneDelegate makeKeyAndVisible done — red placeholder visible, frame=%@",
          NSCoder.string(for: window.frame))

    // Defer DocumentBrowserViewController init to avoid blocking the initial render.
    // UIDocumentBrowserViewController.init() triggers heavy disk work on first launch
    // (~9 seconds) that blocks the main thread. Deferring lets the red placeholder
    // render before the block begins.
    DispatchQueue.main.async { [weak window] in
      NSLog("[MarkEditiOS] SceneDelegate installing DocumentBrowserViewController")
      let documentBrowser = DocumentBrowserViewController()
      window?.rootViewController = documentBrowser
      NSLog("[MarkEditiOS] SceneDelegate DocumentBrowserViewController is now rootVC")
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
