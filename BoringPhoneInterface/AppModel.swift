//
//  AppModel.swift
//  BoringPhoneInterface
//
//  Created by Akshay Patnaik on 2/3/26.
//

import Foundation

struct AppItem: Identifiable {
  let id = UUID()
  let name: String
  let urlScheme: String
  let fallbackURL: String
  let usesShortcut: Bool
  let shortcutImportURL: String?
  let urlSchemes: [String]
  let shortcutImportURLs: [String]
  
  init(name: String,
       urlScheme: String,
       fallbackURL: String,
       usesShortcut: Bool = false,
       shortcutImportURL: String? = nil,
       urlSchemes: [String] = [],
       shortcutImportURLs: [String] = []) {
    self.name = name
    self.urlScheme = urlScheme
    self.fallbackURL = fallbackURL
    self.usesShortcut = usesShortcut
    self.shortcutImportURL = shortcutImportURL
    self.urlSchemes = urlSchemes
    self.shortcutImportURLs = shortcutImportURLs
  }
  
  // PATTERN: "open" + NameNoSpace + "App"
  var generatedShortcutName: String {
    let cleanName = name.replacingOccurrences(of: " (beta)", with: "")
      .replacingOccurrences(of: " ", with: "")
    return "open\(cleanName)App"
  }
  
  var allAppSchemes: [String] {
    var combined: [String] = []
    if !urlScheme.isEmpty { combined.append(urlScheme) }
    combined.append(contentsOf: urlSchemes)
    return combined.filter { !$0.isEmpty }
  }
  
  var allShortcutImports: [String] {
    var links: [String] = []
    if let single = shortcutImportURL, !single.isEmpty { links.append(single) }
    links.append(contentsOf: shortcutImportURLs)
    return links
  }
}

struct AppCategory: Identifiable {
  let id = UUID()
  let title: String
  let apps: [AppItem]
}

class AppData {
  static let categories: [AppCategory] = [
    AppCategory(title: "Core", apps: [
      AppItem(name: "Phone", urlScheme: "https://www.icloud.com/shortcuts/8d221063e1c34f27b7c96eed0064a442", fallbackURL: "", usesShortcut: true, shortcutImportURL: "https://www.icloud.com/shortcuts/8d221063e1c34f27b7c96eed0064a442"),
      AppItem(name: "Messages", urlScheme: "sms://", fallbackURL: "messages://"),
      AppItem(name: "Maps", urlScheme: "maps://", fallbackURL: ""),
      AppItem(name: "Wallet", urlScheme: "shoebox://", fallbackURL: ""),
    ]),
    
    AppCategory(title: "Communication", apps: [
      AppItem(name: "Mail", urlScheme: "message://", fallbackURL: "mailto://"),
      AppItem(name: "WhatsApp", urlScheme: "whatsapp://", fallbackURL: "https://whatsapp.com"),
      AppItem(name: "Discord", urlScheme: "discord://", fallbackURL: "https://discord.com"),
      AppItem(name: "Slack", urlScheme: "slack://", fallbackURL: "https://slack.com"),
      AppItem(name: "Beeper", urlScheme: "beeper://", fallbackURL: "https://beeper.com"),
      AppItem(name: "Google Chat", urlScheme: "googlechat://", fallbackURL: "https://chat.google.com"),
    ]),
    
    AppCategory(title: "Utilities", apps: [
      AppItem(name: "Weather", urlScheme: "weatherchannel://", fallbackURL: "https://weather.com"),
      AppItem(name: "Alarmy", urlScheme: "alarmy://", fallbackURL: ""),
      AppItem(name: "Spotify", urlScheme: "spotify://", fallbackURL: "https://spotify.com"),
      AppItem(name: "Brave", urlScheme: "brave://", fallbackURL: "https://brave.com"),
      AppItem(name: "Files", urlScheme: "shareddocuments://", fallbackURL: ""),
      AppItem(name: "Calculator", urlScheme: "calculator://", fallbackURL: "", usesShortcut: true, shortcutImportURL: "https://www.icloud.com/shortcuts/1ebf5f180c2d444b9e1ee7db1e5f52fe"),
      AppItem(name: "Settings", urlScheme: "App-prefs://", fallbackURL: ""),
    ]),
    
    AppCategory(title: "Work & Dev", apps: [
      AppItem(name: "Notion", urlScheme: "notion://", fallbackURL: "https://notion.so"),
      AppItem(name: "Obsidian", urlScheme: "obsidian://", fallbackURL: "notes://"),
      AppItem(name: "Calendar", urlScheme: "", fallbackURL: "https://calendar.google.com", urlSchemes: ["cron://", "calshow://"]),
      AppItem(name: "GitHub", urlScheme: "github://",  fallbackURL: "https://github.com"),
      AppItem(name: "ChatGPT", urlScheme: "chatgpt://", fallbackURL: "https://chatgpt.com"),
      AppItem(name: "DeepSeek", urlScheme: "deepseek://", fallbackURL: "https://deepseek.com"),
      AppItem(name: "Gemini", urlScheme: "googlegemini://", fallbackURL: "https://gemini.google.com", usesShortcut: true, shortcutImportURL: "https://www.icloud.com/shortcuts/9f57a4563a9c4c39b49a2f2bab32e384"),
    ]),
    
    AppCategory(title: "Life", apps: [
      AppItem(name: "Google Home", urlScheme: "googlehome://", fallbackURL: "", usesShortcut: true, shortcutImportURL: "https://www.icloud.com/shortcuts/19e75d20203c42fcb3852d5825c3e5f9"),
      AppItem(name: "Alexa", urlScheme: "alexa://", fallbackURL: ""),
      AppItem(name: "Tesla", urlScheme: "tesla://", fallbackURL: ""),
      AppItem(name: "Uber", urlScheme: "uber://", fallbackURL: ""),
      AppItem(name: "Transit", urlScheme: "transit://", fallbackURL: ""),
      AppItem(name: "Sweatcoin", urlScheme: "", fallbackURL: "", usesShortcut: true, shortcutImportURL: "https://www.icloud.com/shortcuts/dd3c0738d77c4d12a8372a805f28a55b"),
      AppItem(name: "MyColorado", urlScheme: "mycolorado://", fallbackURL: "https://mycolorado.state.co.us"),
    ])
  ]
}
