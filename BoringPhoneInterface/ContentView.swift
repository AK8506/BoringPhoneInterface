//
//  ContentView.swift
//  BoringPhoneInterface
//
//  Created by Akshay Patnaik on 2/3/26.
//

import SwiftUI
import Combine

// MARK: - Shortcut Manager
class ShortcutManager: ObservableObject {
  static let shared = ShortcutManager()
  
  @Published var installedState: [String: Bool] {
    didSet {
      if let data = try? JSONEncoder().encode(installedState) {
        UserDefaults.standard.set(data, forKey: "installedShortcuts")
      }
    }
  }
  
  private init() {
    if let data = UserDefaults.standard.data(forKey: "installedShortcuts"),
       let decoded = try? JSONDecoder().decode([String: Bool].self, from: data) {
      self.installedState = decoded
    } else {
      self.installedState = [:]
    }
  }
  
  func isInstalled(_ appName: String) -> Bool {
    return installedState[appName] ?? false
  }
  
  func setInstalled(_ appName: String, _ status: Bool) {
    // Force UI update on main thread
    DispatchQueue.main.async {
      self.installedState[appName] = status
    }
  }
}

// MARK: - Main View
struct ContentView: View {
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  @StateObject private var shortcutManager = ShortcutManager.shared
  
  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      
      ScrollView(showsIndicators: false) {
        VStack(spacing: 40) {
          Text("Blubby")
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(Color(white: 0.5))
            .padding(.top, 50)
            .padding(.bottom, 10)
          
          ForEach(AppData.categories) { category in
            VStack(alignment: .leading, spacing: 15) {
              Text(category.title.uppercased())
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color.white)
                .padding(.leading, 2)
              
              LazyVGrid(columns: columns, spacing: 15) {
                ForEach(category.apps) { app in
                  AppButton(app: app)
                }
              }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
          }
          Spacer(minLength: 80)
        }
      }
    }
    .statusBar(hidden: false)
  }
}

// MARK: - App Button Component
struct AppButton: View {
  let app: AppItem
  
  @ObservedObject var shortcutManager = ShortcutManager.shared
  
  var body: some View {
    // 1. Calculate Logic
    let isShortcutApp = app.usesShortcut
    let isInstalled = shortcutManager.isInstalled(app.name)
    
    // Logic: Only show a menu if there are multiple DIFFERENT apps to choose from (e.g. Google Home vs Apple Home).
    // Single-path shortcut apps (like Calculator) should NEVER show a menu
    let hasMenu = app.allAppSchemes.count > 1
    
    // 2. UI Structure
    ZStack {
      // The Visual Button (Main Tap Target)
      Button(action: {
        handlePrimaryAction(isShortcutApp: isShortcutApp, isInstalled: isInstalled)
      }) {
        buttonLabel
      }
      .buttonStyle(PlainButtonStyle())
      .disabled(hasMenu) // Disable direct tap if a menu is required
      
      // The Menu Overlay (Only for multi-app entries like "Home")
      if hasMenu {
        Menu {
          // List the available apps (e.g., Google Home, Apple Home)
          ForEach(app.allAppSchemes, id: \.self) { scheme in
            Button(readableName(from: scheme)) {
              openScheme(scheme)
            }
          }
        } label: {
          // Invisible hit target that matches the button size
          Color.white.opacity(0.001)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
    .frame(height: 60)
  }
  
  // App opening workflow, handles shortcuts
  
  func handlePrimaryAction(isShortcutApp: Bool, isInstalled: Bool) {
    if isShortcutApp {
      if isInstalled {
        // SCENARIO 1: App knows it's installed -> Run it.
        runShortcut()
      } else {
        // SCENARIO 2: App thinks it's missing -> Open Install Link.
        // Next time they click, it will run (Scenario 1).
        shortcutManager.setInstalled(app.name, true)
        openInstallLink()
      }
    } else {
      // Standard App (Single scheme)
      openScheme(app.urlScheme)
    }
  }
  
  func runShortcut() {
    // MUST use shortcuts:// to run. iCloud links only install.
    let encodedName = app.generatedShortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "shortcuts://run-shortcut?name=\(encodedName)"
    openScheme(urlString)
  }
  
  func openInstallLink() {
    // Use the first available import link
    let link = app.shortcutImportURL ?? app.shortcutImportURLs.first ?? ""
    if !link.isEmpty {
      openURL(link)
    }
  }
  
  func openScheme(_ scheme: String) {
    if let url = URL(string: scheme) {
      UIApplication.shared.open(url)
    }
  }
  
  func openURL(_ string: String) {
    if let url = URL(string: string) {
      UIApplication.shared.open(url)
    }
  }
  
  // Visuals
  
  var buttonLabel: some View {
    Text(app.name)
      .font(.system(size: 16, weight: .medium, design: .monospaced))
      .foregroundColor(Color(white: 0.85))
      .frame(maxWidth: .infinity)
      .frame(height: 60)
      .background(Color.black)
      .overlay(Rectangle().stroke(Color(white: 0.2), lineWidth: 1))
      .contentShape(Rectangle())
  }
  
  private func readableName(from scheme: String) -> String {
    return scheme.replacingOccurrences(of: "://", with: "").capitalized
  }
}
