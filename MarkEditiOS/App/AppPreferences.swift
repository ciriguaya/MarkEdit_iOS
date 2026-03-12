//
//  AppPreferences.swift
//  MarkEditiOS
//
//  Lightweight UserDefaults wrapper for iOS editor settings.
//

import UIKit
import MarkEditCore

enum AppPreferences {
  enum Editor {
    /// The user's explicitly stored theme name, or "" if they have never chosen one
    /// (meaning the editor should follow the system appearance automatically).
    static var theme: String {
      get { UserDefaults.standard.string(forKey: "ios.editor.theme") ?? "" }
      set { UserDefaults.standard.set(newValue, forKey: "ios.editor.theme") }
    }

    /// Resolves the theme to apply to the editor, using the stored preference when
    /// the user has made an explicit choice, or falling back to a system-appearance-
    /// appropriate default otherwise.
    ///
    /// Always call this from a view context so `style` reflects the actual window
    /// appearance — do NOT use `UITraitCollection.current.userInterfaceStyle` here.
    static func effectiveTheme(for style: UIUserInterfaceStyle) -> String {
      let stored = UserDefaults.standard.string(forKey: "ios.editor.theme") ?? ""
      if !stored.isEmpty { return stored }
      return style == .dark ? "GitHub Dark" : "GitHub Light"
    }

    static var fontSize: Double {
      get {
        let value = UserDefaults.standard.double(forKey: "ios.editor.fontSize")
        return value > 0 ? value : 15
      }
      set { UserDefaults.standard.set(newValue, forKey: "ios.editor.fontSize") }
    }

    static var lineWrapping: Bool {
      get { UserDefaults.standard.object(forKey: "ios.editor.lineWrapping") as? Bool ?? true }
      set { UserDefaults.standard.set(newValue, forKey: "ios.editor.lineWrapping") }
    }

    static var showLineNumbers: Bool {
      get { UserDefaults.standard.object(forKey: "ios.editor.showLineNumbers") as? Bool ?? false }
      set { UserDefaults.standard.set(newValue, forKey: "ios.editor.showLineNumbers") }
    }
  }
}
